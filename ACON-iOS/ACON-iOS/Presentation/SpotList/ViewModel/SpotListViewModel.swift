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
    
    var showErrorView: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var errorType: SpotListErrorType? = nil
    
    var spotList: [SpotModel] = []
    
    var hasSpotListChanged: Bool = false
    
    var currentDong: String = ""
    
    var userCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    
    // MARK: - Filter
    
    var spotType: ObservablePattern<SpotType> = ObservablePattern(nil)
    
    var filterList: [SpotFilterModel] = []
    
    var walkingTime: SpotType.WalkingDistanceType = .defaultValue
    
    var restaurantPrice: SpotType.RestaurantPriceType? = nil
    
    var cafePrice: SpotType.CafePriceType? = nil
    
    
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
        spotType.value = nil
        filterList.removeAll()
        walkingTime = .defaultValue
        restaurantPrice = nil
        cafePrice = nil
    }
    
}


// MARK: - Networking

extension SpotListViewModel {
    
    func getDong() {
        let requestQuery = GetDongRequestQuery(latitude: userCoordinate.latitude,
                                               longitude: userCoordinate.longitude)
        
        ACService.shared.spotListService.getDong(
            query: requestQuery) { [weak self] response in
                switch response {
                case .success(let data):
                    self?.currentDong = data.area
                    self?.showErrorView.value = false
                    self?.onSuccessGetDong.value = true
                case .reIssueJWT:
                    self?.handleReissue { [weak self] in
                        self?.getDong()
                    }
                case .requestErr(let error):
                    print("🥑getDong requestErr: \(error)")
                    if error.code == 40405 {
                        self?.errorType = .unsupportedRegion
                        self?.showErrorView.value = true
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
            return SpotFilter(category: filter.category.serverKey,
                                       optionList: filter.optionList)
        }
        
        let requestBody = PostSpotListRequest(
            latitude: userCoordinate.latitude,
            longitude: userCoordinate.longitude,
            condition: SpotCondition(
                spotType: spotType.value?.serverKey,
                filterList: filterList.isEmpty ? nil : filterListDTO,
                walkingTime: walkingTime.serverKey,
                priceRange: spotType.value == .restaurant ? restaurantPrice?.serverKey : cafePrice?.serverKey
            )
        )
        
        ACService.shared.spotListService.postSpotList(requestBody: requestBody) { [weak self] response in
            switch response {
            case .success(let data):
                let spotList: [SpotModel] = data.spotList.map { data in
                    let spot = SpotModel(
                        id: data.id,
                        imageURL: data.image,
                        matchingRate: data.matchingRate,
                        type: data.type,
                        name: data.name,
                        walkingTime: data.walkingTime
                    )
                    return spot
                }
                self?.hasSpotListChanged = spotList != self?.spotList
                self?.spotList = spotList
                if spotList.isEmpty {
                    self?.errorType = .emptyList
                    self?.showErrorView.value = true
                } else {
                    self?.showErrorView.value = false
                }
                self?.onSuccessPostSpotList.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postSpotList()
                }
            case .requestErr(let error):
                print("🥑post spotList requestErr: \(error)")
                if error.code == 40405 {
                    self?.errorType = .unsupportedRegion
                    self?.showErrorView.value = true
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
        postSpotList()
    }
    
}
