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
    
    var spotList: [SpotModel] = []
    
    var isUpdated: Bool = false
    
    // TODO: userCoordinate 기본값 빼고 옵셔널로 만들기 (지금은 필터 설정했을 때 좌표가 0,0으로 찍히는 문제때문에 좌표 넣어둠...)
    var userCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.559171017384145, longitude: 126.9219534442884)
    
    
    // MARK: - Filter
    
    var spotType: ObservablePattern<SpotType> = ObservablePattern(nil)
    
    var filterList: [SpotFilterListModel] = [] // TODO: SpotCondition으로 바꾸기
    
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
    
    func postSpotList() {
        print("🤍🤍🤍🤍spotType: \(spotType)")
        let requestBody = PostSpotListRequest(
            latitude: userCoordinate.latitude,
            longitude: userCoordinate.longitude,
            condition: SpotCondition(
                spotType: spotType.value?.serverKey ?? "",
                filterList: filterList.map { filterList in
                    let filterList = SpotFilterList(
                        category: filterList.category.serverKey,
                        optionList: filterList.optionList)
                    return filterList
                },
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
//                print("🥑spot:", spotList)
                self?.isUpdated = spotList != self?.spotList
                self?.spotList = spotList
                self?.isPostSpotListSuccess.value = true
            default:
                print("🥑Failed To Post")
                self?.isPostSpotListSuccess.value = false
                return
            }
        }
        // TODO: TimeOut 설정하기; 서버가 다운 된 경우 isSuccess가 set이 안돼서 무한 로딩됨
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
