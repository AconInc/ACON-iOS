//
//  SettingViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/13/25.
//

import UIKit

final class SettingViewModel: Serviceable {

    var onPostLogoutSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
    
    func postLogout() {
        let refreshToken = UserDefaults.standard.string(forKey: StringLiterals.UserDefaults.refreshToken) ?? ""
        ACService.shared.authService.postLogout(
            PostLogoutRequest(refreshToken: refreshToken)) { result in
                switch result {
                case .success:
                    for key in UserDefaults.standard.dictionaryRepresentation().keys {
                        UserDefaults.standard.removeObject(forKey: key.description)
                    }
                    AmplitudeManager.shared.reset()
                    self.onPostLogoutSuccess.value = true
                case .reIssueJWT:
                    self.handleReissue { [weak self] in
                        self?.postLogout()
                    }
                case .networkFail:
                    self.handleNetworkError { [weak self] in
                        self?.postLogout()
                    }
                default:
                    self.onPostLogoutSuccess.value = false
                }
        }
    }
    
}
