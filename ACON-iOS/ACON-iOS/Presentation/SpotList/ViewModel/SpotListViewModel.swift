//
//  SpotListViewModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/13/25.
//

import CoreLocation
import UIKit

class SpotListViewModel: Serviceable {
    
    // MARK: - Properties

    var onSuccessPostSpotList: ObservablePattern<Bool> = ObservablePattern(nil)

    var onFinishRefreshingSpotList: ObservablePattern<Bool> = ObservablePattern(nil)

    var errorType: SpotListErrorType? = nil

    var spotList = SpotListModel()
    
    var userCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    private var lastNetworkLocation: CLLocation?
    
    private let locationDistanceThreshold: Double = 1300
    
    private var userLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)

    private var periodicLocationCheckTimer: Timer?
    
    var needToShowToast: ObservablePattern<Bool> = ObservablePattern(nil)


    // MARK: - Filter

    var spotType: SpotType = .restaurant

    var filterList: [SpotFilterModel] = []


    // MARK: - Methods

    func updateLocationAndPostSpotList() {
        // 위치 권한 확인 및 업데이트 시작
        ACLocationManager.shared.addDelegate(self)
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
    }
    
    func resetConditions() {
        filterList.removeAll()
    }
    
}


// MARK: - Networking

extension SpotListViewModel {

    func postSpotList() {
        let filterListDTO = filterList.map { filter in
            return SpotFilterDTO(category: filter.category.serverKey,
                                       optionList: filter.optionList)
        }

        let requestBody = PostSpotListRequest(
            latitude: userCoordinate.latitude,
            longitude: userCoordinate.longitude,
            condition: SpotConditionDTO(
                spotType: spotType.serverKey,
                filterList: filterList.isEmpty ? nil : filterListDTO
            )
        )

        ACService.shared.spotListService.postSpotList(requestBody: requestBody) { [weak self] response in
            switch response {
            case .success(let data):
                let spotList: SpotListModel = SpotListModel(from: data)

                self?.spotList = spotList

                if spotList.spotList.isEmpty { self?.errorType = .emptyList }
                self?.onSuccessPostSpotList.value = true

            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postSpotList()
                }

            case .requestErr(let error):
                if error.code == 40405 {
                    self?.errorType = .unsupportedRegion
                } else {
                    self?.handleNetworkError { [weak self] in
                        self?.postSpotList()
                    }
                }
                self?.onSuccessPostSpotList.value = false

            default:
                self?.handleNetworkError { [weak self] in
                    self?.postSpotList()
                }
                self?.onSuccessPostSpotList.value = false
            }
        }
    }

    func postGuidedSpot(spotID: Int64) {
        ACService.shared.spotDetailService.postGuidedSpot(spotID: spotID){ [weak self] response in
            switch response {
            case .success:
                return
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postGuidedSpot(spotID: spotID)
                }
            default:
                return
            }
        }
    }

}


// MARK: - ACLocationManagerDelegate

extension SpotListViewModel: ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager, didUpdateLocation location: CLLocation) {
        ACLocationManager.shared.removeDelegate(self)
        userLocation = location
        userCoordinate = location.coordinate
        postSpotList()
    }

}


// MARK: - 주기적 위치 체크

extension SpotListViewModel {
    
    func startPeriodicLocationCheck() {
        checkLocationChange()
        stopPeriodicLocationCheck()
        
        periodicLocationCheckTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            checkLocationChange()
        }
    }
    
    func stopPeriodicLocationCheck() {
        periodicLocationCheckTimer?.invalidate()
        periodicLocationCheckTimer = nil
    }
    
    func checkLocationChange() {
        guard let lastLocation = lastNetworkLocation else { return }
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        let hasToast = window.subviews.contains { $0 is ACToastView }
        guard !hasToast else { return }
        
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
        guard let distance = lastNetworkLocation?.distance(from: userLocation) else { return }
        print("🧇 \(distance)")
        if distance >= locationDistanceThreshold {
            print("🧇 위치 변화 감지: \(distance)m")
            needToShowToast.value = true
        }
    }
    
}
