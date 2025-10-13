//
//  PreferenceViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/16/25.
//

import Foundation

class PreferenceViewModel: Serviceable {
    
    // MARK: - Networking Properties
    
    var onPutPreferenceSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
 
    
    // MARK: - Networking
    
    func putPreference(_ dislikeFoodList: [String]) {
        ACService.shared.preferenceService.putPreference(requestBody: PutPreferenceRequest(dislikeFoodList: dislikeFoodList)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success:
                onPutPreferenceSuccess.value = true
                if !AuthManager.shared.hasPreference {
                    UserDefaultsUtils.set(true, forKey: .hasPreference)
                }
            case .reIssueJWT:
                self.handleReissue {
                    self.putPreference(dislikeFoodList)
                }
            case .networkFail:
                self.handleNetworkError {
                    self.putPreference(dislikeFoodList)
                }
            default:
                onPutPreferenceSuccess.value = false
            }
        }
    }
    
}
