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

    private var isPeriodicLocationCheck = false
    

    // MARK: - Filter

    var spotType: SpotType = .restaurant

    var filterList: [SpotFilterModel] = []


    // MARK: - LifeCycle
    
    deinit {
        ACLocationManager.shared.removeDelegate(self)
    }
    
    
    // MARK: - Methods

    // NOTE: - SpotListView 나타날 때
    func startLocationTracking() {
        ACLocationManager.shared.addDelegate(self)
        updateLocationAndPostSpotList()
        startPeriodicLocationCheck()
    }
   
    // NOTE: - SpotListView 사라질 때
    func stopLocationTracking() {
        ACLocationManager.shared.removeDelegate(self)
        stopPeriodicLocationCheck()
    }
    
    func updateLocationAndPostSpotList() {
        isPeriodicLocationCheck = false
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
                self?.onSuccessPostSpotList.value = true
                self?.lastNetworkLocation = self?.userLocation

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
        userLocation = location
        userCoordinate = location.coordinate
        
        if isPeriodicLocationCheck {
            checkLocationChange()
        } else {
            postSpotList()
        }
    }

}


// MARK: - 주기적 위치 체크

extension SpotListViewModel {
    
    func startPeriodicLocationCheck() {
        requestCurrentLocationForCheck()
        stopPeriodicLocationCheck()
        
        periodicLocationCheckTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.requestCurrentLocationForCheck()
        }
    }
        
    func stopPeriodicLocationCheck() {
        periodicLocationCheckTimer?.invalidate()
        periodicLocationCheckTimer = nil
    }
        
    private func requestCurrentLocationForCheck() {
        guard let lastLocation = lastNetworkLocation else { return }
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        let hasToast = window.subviews.contains { $0 is ACToastView }
        
        guard !hasToast else {
            return
        }
        
        isPeriodicLocationCheck = true
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
    }
        
    private func checkLocationChange() {
        guard let lastLocation = lastNetworkLocation else { return }
        
        let distance = lastLocation.distance(from: userLocation)
        print("🧇 거리: \(distance)")
        if distance >= locationDistanceThreshold {
            print("🧇 위치 변화 감지: \(distance)m")
            needToShowToast.value = true
        }
        
        isPeriodicLocationCheck = false
    }
    
}
