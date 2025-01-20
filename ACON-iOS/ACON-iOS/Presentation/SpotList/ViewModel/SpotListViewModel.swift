//
//  SpotListViewModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/13/25.
//

import CoreLocation
import Foundation

class SpotListViewModel {
    
    // MARK: - Properties
    
    var spotList: [SpotModel] = []
    
    var isUpdated: Bool = false
    
    var isNetworkingSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
    
    
    // MARK: - Filter
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
    
    func fetchSpotList() {
        
        // TODO: spotList와 새로 fetch된 데이터 비교하여 isUpdated set
        
        isUpdated = true
        
        isNetworkingSuccess.value = true
    }
}


// MARK: - ACLocationManagerDelegate

extension SpotListViewModel: ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager,
                         didUpdateLocation coordinate: CLLocationCoordinate2D) {
        
        print("🛠️ coordinate: \(coordinate)")
        
        // TODO: 추천 장소 리스트 POST 서버통신 -> spotListModel.Spot POST
    }
}
