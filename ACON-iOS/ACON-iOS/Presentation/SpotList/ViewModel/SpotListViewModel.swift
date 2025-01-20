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
    
    
    // 위치 정보를 바인딩할 프로퍼티
    var currentLocation: ObservablePattern<CLLocationCoordinate2D> = ObservablePattern(nil)
    var locationError: ObservablePattern<String> = ObservablePattern(nil)
    
    
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
        // 위치 권한 요청 및 업데이트 시작
        ACLocationManager.shared.requestLocationAuthorization()
        ACLocationManager.shared.startUpdatingLocation()
    }
    
}


extension SpotListViewModel: ACLocationManagerDelegate {
    
    // MARK: - ACLocationManagerDelegate Methods
    func locationManager(_ manager: ACLocationManager, didUpdateLocation coordinate: CLLocationCoordinate2D) {
        // 위치 업데이트 시 호출
        currentLocation = coordinate
    }
    
//    func locationManager(_ manager: ACLocationManager, didFailWithError error: Error, vc: UIViewController?) {
//        // 에러 발생 시 호출
//        locationError = error.localizedDescription
//    }
    
    func locationManagerDidChangeAuthorization(_ manager: ACLocationManager) {
        // 권한 변경 시 호출
        if manager.locationManager.authorizationStatus == .authorizedWhenInUse ||
           manager.locationManager.authorizationStatus == .authorizedAlways {
            manager.locationManager.requestLocation()
        }
    }
}
