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
    
    var onSuccessGetDong: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var onSuccessPostSpotList: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var onFinishRefreshingSpotList: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var errorType: SpotListErrorType? = nil
    
    var restaurantList: [SpotModel] = []
    var cafeList: [SpotModel] = []
    
    var currentDong: String = ""
    
    var userCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    
    // MARK: - Filter
    
    var spotType: SpotType = .restaurant
    
    var filterList: [SpotFilterModel] = []
    
    
    // MARK: - Methods
    
    init() {
        ACLocationManager.shared.addDelegate(self)
    }
    
    deinit {
        ACLocationManager.shared.removeDelegate(self)
    }
    
    func requestLocation() {
        // 위치 권한 확인 및 업데이트 시작
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
    }
    
    func resetConditions() {
        filterList.removeAll()
    }
    
}


// MARK: - Networking

extension SpotListViewModel {
    
    func getDong() {
        let requestQuery = GetDongRequest(latitude: userCoordinate.latitude,
                                               longitude: userCoordinate.longitude)
        
        ACService.shared.spotListService.getDong(
            query: requestQuery) { [weak self] response in
                switch response {
                case .success(let data):
                    self?.currentDong = data.area
                    self?.onSuccessGetDong.value = true
                case .reIssueJWT:
                    self?.handleReissue { [weak self] in
                        self?.getDong()
                    }
                case .requestErr(let error):
                    print("🥑getDong requestErr: \(error)")
                    if error.code == 40405 {
                        self?.errorType = .unsupportedRegion
                    } else {
                        self?.errorType = .serverRequestFail // TODO: 에러 뷰 또는 Alert 띄우기
                    }
                    self?.onSuccessGetDong.value = false
                default:
                    print("🥑vm - Failed to get dong")
                    self?.onSuccessGetDong.value = false
                    return
                }
            }
    }
    
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
                let spotList: [SpotModel] = data.spotList.map { SpotModel(from: $0) }

                if self?.spotType == .restaurant {
                    self?.restaurantList = spotList
                } else {
                    self?.cafeList = spotList
                }

                if spotList.isEmpty { self?.errorType = .emptyList }
                self?.onSuccessPostSpotList.value = true

            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postSpotList()
                }

            case .requestErr(let error):
                print("🥑post spotList requestErr: \(error)")
                if error.code == 40405 {
                    self?.errorType = .unsupportedRegion
                } else {
                    self?.errorType = .serverRequestFail // TODO: 에러 뷰 또는 Alert 띄우기
                }
                self?.onSuccessPostSpotList.value = false

            default:
                print("🥑Failed To Post")
                self?.onSuccessPostSpotList.value = false
                return
            }
        }
    }
    
}


// MARK: - ACLocationManagerDelegate

extension SpotListViewModel: ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager,
                         didUpdateLocation coordinate: CLLocationCoordinate2D) {
        print("🛠️ coordinate: \(coordinate)")
        
        userCoordinate = coordinate
        getDong()
    }
    
}
