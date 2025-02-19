//
//  LocalVerificationEditViewModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/17/25.
//

import Foundation

class LocalVerificationEditViewModel: Serviceable {
    
    // MARK: - Properties
    
    var verifiedAreaList: [VerifiedAreaModel] = []
    
    var isAppendingVerifiedAreaList: Bool = false
    
    
    // MARK: - Networking Properties
    
    var onGetVerifiedAreaListSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var onDeleteVerifiedAreaSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var deletingVerifiedArea: VerifiedAreaModel?
    
    
    // MARK: - Networking
    
    func getVerifiedAreaList() {
        verifiedAreaList.removeAll()
        
        ACService.shared.localVerificationService.getVerifiedAreaList { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                let newVerifiedAreaList: [VerifiedAreaModel] = data.verifiedAreaList.map {
                    VerifiedAreaModel(id: $0.id, name: $0.name)
                }
                verifiedAreaList = newVerifiedAreaList
                onGetVerifiedAreaListSuccess.value = true
            case .reIssueJWT:
                self.handleReissue {
                    self.getVerifiedAreaList()
                }
            default:
                onGetVerifiedAreaListSuccess.value = false
            }
        }
    }
    
    func postDeleteVerifiedArea(_ area: VerifiedAreaModel) {
        print("postDeleteVerifiedArea")
        deletingVerifiedArea = area
        let verifiedAreaIDStr = String(area.id)
        
        ACService.shared.localVerificationService.deleteVerifiedArea(verifiedAreaID: verifiedAreaIDStr) { [weak self] response in
            switch response {
            case .success:
                self?.onDeleteVerifiedAreaSuccess.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postDeleteVerifiedArea(area)
                }
            default:
                print("🥑 VM - Fail to delete VerifiedArea")
                self?.onDeleteVerifiedAreaSuccess.value = false
                return
            }
        }
    }
    
}
