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
    
    var isPostSpotListSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var spotList: [SpotModel] = [SpotModel(id: 0,
                                           imageURL: "imgEx1",
                                           matchingRate: 100,
                                           type: "CAFE",
                                           name: "카페1",
                                           walkingTime: 5
                                          )]
    
    var isUpdated: Bool = false
    
    var userCoordinate: CLLocationCoordinate2D? = nil
    
    
    // MARK: - Filter
    
    // I will fix this on other branch ^^
    var spotType: ObservablePattern<SpotType> = ObservablePattern(.restaurant)
    
    var filter: SpotFilterModel = .init(
        latitude: 0,
        longitude: 0,
        condition: SpotConditionModel(
            spotType: SpotType.restaurant.text,
            filterList: [],
            walkingTime: -1,
            priceRange: -1
        )
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
    
    func postSpotList() {
        let requestBody = PostSpotListRequest(
            latitude: userCoordinate?.latitude ?? 0,
            longitude: userCoordinate?.longitude ?? 0,
            condition: SpotCondition(
                spotType: SpotType.restaurant.serverKey,
                filterList: [],
                walkingTime: -1,
                priceRange: -1
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
                print("🥑spot:", spotList)
                self?.isUpdated = spotList == self?.spotList
                self?.spotList = spotList
                self?.isPostSpotListSuccess.value = true
            default:
                print("🥑Failed To Post")
                self?.isPostSpotListSuccess.value = false
                return
            }
        }
        // TODO: 네트워크 실패인 경우 isSuccess가 set이 안돼서 무한 로딩인데,,,, API가 살아나면 이 문제를 걱정하지 않아도 되는지,,, 확인하기,,,
    }
    
}


// MARK: - ACLocationManagerDelegate

extension SpotListViewModel: ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager,
                         didUpdateLocation coordinate: CLLocationCoordinate2D) {
        print("🛠️ coordinate: \(coordinate)")
        userCoordinate = coordinate
    }
    
}
