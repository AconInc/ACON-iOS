//
//  SpotListFilterViewModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import CoreLocation
import Foundation

class SpotListFilterViewModel {
    
    // MARK: - Properties
    
    var spotType: ObservablePattern<SpotType> = ObservablePattern(.restaurant)
    
    var userCoordinate: CLLocationCoordinate2D?
    
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
    
}

extension SpotListFilterViewModel: ACLocationManagerDelegate {

    func locationManager(_ manager: ACLocationManager, didUpdateLocation coordinate: CLLocationCoordinate2D) {
        print("성공 - 위도: \(coordinate.latitude), 경도: \(coordinate.longitude)")
        self.userCoordinate = coordinate
//        pushToLocalMapVC()
    }

}
