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
    
    var isFirstPage: ObservablePattern<Bool> = ObservablePattern(true)
    
    private var givenSpotList: ObservablePattern<[SpotModel]> = ObservablePattern(SpotModel.dummy)
    
    var firstSpotList: [SpotModel] = []
    var secondSpotList: [SpotModel] = []
    
    
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
        givenSpotList.bind { [weak self] spotList in
            guard let self = self,
                  let spotList = spotList else { return }
            
            splitSpotList(spotList)
        }
        // 델리게이트 등록
        ACLocationManager.shared.addDelegate(self)
    }
    
    deinit {
        // 델리게이트 제거
        ACLocationManager.shared.removeDelegate(self)
    }
    
    
    // TODO: 서버와 논의 후 변경 예정
    private func splitSpotList(_ spotList: [SpotModel]) {
        firstSpotList = Array(spotList.prefix(2))
        secondSpotList = Array(spotList.dropFirst(2))
    }
    
    func requestLocation() {
        // 위치 권한 확인 및 업데이트 시작
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
    }
    
}


extension SpotListViewModel: ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager,
                         didUpdateLocation coordinate: CLLocationCoordinate2D) {
        
        print("🛠️ coordinate: \(coordinate)")
        
        
        // TODO: 추천 장소 리스트 POST 서버통신 -> spotListModel.Spot POST
    }
}
