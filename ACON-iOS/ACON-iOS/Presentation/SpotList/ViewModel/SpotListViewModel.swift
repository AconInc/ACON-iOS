//
//  SpotListViewModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/13/25.
//

import CoreLocation
import UIKit

class SpotListViewModel {
    
    // MARK: - Properties
    
    var onSuccessGetAddress: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var isPostSpotListSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var spotList: [SpotModel] = []
    
    var isUpdated: Bool = false
    
    var userCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    
    // MARK: - Filter
    
    var spotType: ObservablePattern<SpotType> = ObservablePattern(nil)
    
    var filterList: [SpotFilterListModel] = [] // TODO: SpotCondition으로 바꾸기
    
    var walkingTime: SpotType.WalkingDistanceType = .fifteen
    
    var restaurantPrice: SpotType.RestaurantPriceType = .tenThousand
    
    var cafePrice: SpotType.CafePriceType = .fiveThousand
    
    var spotCondition = SpotConditionModel(
        spotType: .restaurant,
        filterList: [],
        walkingTime: -1,
        priceRange: -1
    )
    
    
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
    
}


// MARK: - Networking

extension SpotListViewModel {
    
    func getAddress() {
        ACService.shared.spotListService.getAddress(latitude: userCoordinate?.latitude ?? 0,
                                                    longitude: userCoordinate?.longitude ?? 0) { [weak self] response in
            switch response {
            case .success(let data):
                self?.myAddress = data.area
                self?.onSuccessGetAddress.value = true
            default:
                self?.onSuccessGetAddress.value = false
                return
            }
        }
    }
    
    func postSpotList() {
        let requestBody = PostSpotListRequest(
            latitude: userCoordinate?.latitude ?? 0,
            longitude: userCoordinate?.longitude ?? 0,
            condition: SpotCondition(
                spotType: spotType.value?.serverKey ?? "",
                filterList: filterList.map { filterList in
                    let filterList = SpotFilterList(
                        category: filterList.category.serverKey,
                        optionList: filterList.optionList)
                    return filterList
                },
                walkingTime: walkingTime.serverKey,
                priceRange: spotType.value == .restaurant ? restaurantPrice.serverKey : cafePrice.serverKey
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
                self?.isUpdated = spotList != self?.spotList
                self?.spotList = spotList
                self?.isPostSpotListSuccess.value = true
            default:
                print("🥑Failed To Post")
                self?.isPostSpotListSuccess.value = false
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
        
        postSpotList()
    }
    
}
