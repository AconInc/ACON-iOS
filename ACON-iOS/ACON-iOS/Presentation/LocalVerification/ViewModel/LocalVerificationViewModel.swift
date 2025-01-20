//
//  LocalVerificationViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import CoreLocation
import Foundation

class LocalVerificationViewModel {
    
    let onSuccessPostLocalArea: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var localArea: ObservablePattern<String> = ObservablePattern(nil)
    
    let isLocationChecked: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var userCoordinate: CLLocationCoordinate2D? = nil
    
    init() {
        ACLocationManager.shared.addDelegate(self)
    }

    deinit {
       ACLocationManager.shared.removeDelegate(self)
    }
    
    func checkLocation() {
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
    }
    
    func postLocalArea() {
        let requestBody = PostLocalAreaRequest(latitude: userCoordinate?.latitude ?? 0,
                                               longitude: userCoordinate?.longitude ?? 0)
        ACService.shared.localVerificationService.postLocalArea(requestBody: requestBody) { [weak self] response in
            switch response {
            case .success(let data):
                self?.onSuccessPostLocalArea.value = true
                self?.localArea.value = data.area
            default:
                print("Failed To Post")
                self?.onSuccessPostLocalArea.value = false
                return
            }
        }
    }
    
}

extension LocalVerificationViewModel: ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager, didUpdateLocation coordinate: CLLocationCoordinate2D) {
        print("성공 - 위도: \(coordinate.latitude), 경도: \(coordinate.longitude)")
        self.userCoordinate = coordinate
        isLocationChecked.value = true
    }
    
}
