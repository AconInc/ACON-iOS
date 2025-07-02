//
//  LocalVerificationViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import CoreLocation
import Foundation

class LocalVerificationViewModel: Serviceable {
    
    // MARK: - Properties
    
    var flowType: LocalVerificationFlowType
    
    var localAreaName: ObservablePattern<String> = ObservablePattern(nil)
    
    var isLocationChecked: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var isLocationKorea: Bool = true
    
    var userCoordinate: CLLocationCoordinate2D? = nil
    
    var verifiedAreaList: [VerifiedAreaModel] = []
    
    var isSwitching: Bool = false
    
    var postLocalAreaErrorType: PostLocalAreaErrorType? = nil
    
    var deleteVerifiedAreaErrorType: DeleteVerifiedAreaErrorType? = nil
    
    var postReplaceVerifiedAreaErrorType: PostReplaceVerifiedAreaErrorType? = nil
    
    
    // MARK: - Networking Properties
    
    let onPostLocalAreaSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var onGetVerifiedAreaListSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var onDeleteVerifiedAreaSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var onPostReplaceVerifiedAreaSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
    
    
    // MARK: - LifeCycle
    
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
            case .success:
                self?.onPostLocalAreaSuccess.value = true
            case .requestErr(let error):
                self?.onPostLocalAreaSuccess.value = false
                if error.code == 40012 {
                    self?.postLocalAreaErrorType = .unsupportedRegion
                } else if error.code == 40032 {
                    self?.postLocalAreaErrorType = .outOfRange
                }
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postLocalArea()
                }
            case .networkFail:
                self?.handleNetworkError { [weak self] in
                    self?.postLocalArea()
                }
            default:
                self?.onPostLocalAreaSuccess.value = false
            }
        }
    }
    
}


// MARK: - Verified Area Edit

extension LocalVerificationViewModel {
    
    func getVerifiedAreaList() {
        verifiedAreaList.removeAll()
        
        ACService.shared.localVerificationService.getVerifiedAreaList { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                let newVerifiedAreaList: [VerifiedAreaModel] = data.verifiedAreaList.map {
                    VerifiedAreaModel(id: $0.verifiedAreaId, name: $0.name)
                }
                verifiedAreaList = newVerifiedAreaList
                onGetVerifiedAreaListSuccess.value = true
            case .reIssueJWT:
                self.handleReissue { [weak self] in
                    self?.getVerifiedAreaList()
                }
            default:
                self.handleNetworkError { [weak self] in
                    self?.getVerifiedAreaList()
                }
            }
        }
    }
    
    func deleteVerifiedArea(_ area: VerifiedAreaModel) {
        ACService.shared.localVerificationService.deleteVerifiedArea(verifiedAreaID: String(area.id)) { [weak self] response in
            switch response {
            case .success:
                self?.onDeleteVerifiedAreaSuccess.value = true
            case .requestErr(let error):
                if error.code == 40054 {
                    self?.deleteVerifiedAreaErrorType = .unsupportedRegion
                } else if error.code == 40032 {
                    self?.deleteVerifiedAreaErrorType = .onlyOne
                } else if error.code == 40055 {
                    self?.deleteVerifiedAreaErrorType = .timeOut
                } else {
                    self?.handleNetworkError { [weak self] in
                        self?.deleteVerifiedArea(area)
                    }
                }
                self?.onDeleteVerifiedAreaSuccess.value = false
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.deleteVerifiedArea(area)
                }
            default:
                self?.handleNetworkError { [weak self] in
                    self?.deleteVerifiedArea(area)
                }
            }
        }
    }
    
    func postReplaceVerifiedArea() {
        let requestBody = PostReplaceVerifiedAreaRequest(previousVerifiedAreaId: verifiedAreaList[0].id,
                                                         latitude: userCoordinate?.latitude ?? 0, longitude: userCoordinate?.longitude ?? 0)
        
        ACService.shared.localVerificationService.postReplaceVerifiedArea(requestBody: requestBody) { [weak self] response in
            switch response {
            case .success:
                self?.onPostReplaceVerifiedAreaSuccess.value = true
            case .requestErr(let error):
                self?.onPostReplaceVerifiedAreaSuccess.value = false
                if error.code == 40012 {
                    self?.postReplaceVerifiedAreaErrorType = .unsupportedRegion
                } else if error.code == 40054 {
                    self?.postReplaceVerifiedAreaErrorType = .notValid
                } else if error.code == 40055 {
                    self?.postReplaceVerifiedAreaErrorType = .timeOut
                } else if error.code == 40056 {
                    self?.postReplaceVerifiedAreaErrorType = .notUniqueVerifiedArea
                } else {
                    self?.handleNetworkError { [weak self] in
                        self?.postReplaceVerifiedArea()
                    }
                }
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postReplaceVerifiedArea()
                }
            default:
                self?.handleNetworkError { [weak self] in
                    self?.postReplaceVerifiedArea()
                }
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
