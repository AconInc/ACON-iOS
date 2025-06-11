//
//  LocalVerificationViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import CoreLocation
import Foundation

class LocalVerificationViewModel: Serviceable {
    
    var flowType: LocalVerificationFlowType
    
    let onSuccessPostLocalArea: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var verifiedArea: ObservablePattern<VerifiedAreaModel> = ObservablePattern(nil)
    
    var localAreaName: ObservablePattern<String> = ObservablePattern(nil)
    
    var isLocationChecked: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var isLocationKorea: Bool = true
    
    var userCoordinate: CLLocationCoordinate2D? = nil
    
    init(flowType: LocalVerificationFlowType) {
        self.flowType = flowType
        
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
                self?.verifiedArea.value = VerifiedAreaModel(id: data.id, name: data.name)
                self?.localAreaName.value = data.name
                self?.onSuccessPostLocalArea.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postLocalArea()
                }
            default:
                print("🥑Failed To Post Local Area")
                self?.onSuccessPostLocalArea.value = false
                return
            }
        }
    }
    
}


// MARK: - 위치 정보 가져오기

extension LocalVerificationViewModel: ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager, didUpdateLocation location: CLLocation) {
        self.userCoordinate = location.coordinate
        self.isLocationKorea = LocationUtils.isKorea(location.coordinate.latitude, location.coordinate.longitude)
        isLocationChecked.value = true
    }
    
}
