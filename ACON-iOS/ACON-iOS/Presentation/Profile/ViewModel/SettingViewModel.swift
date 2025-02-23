//
//  SettingViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/13/25.
//

import UIKit

class SettingViewModel: Serviceable {
    
    var isLatestVersion: Bool = true
    
    // TODO: - 앱 버전 체크 로직 -> Sprint 3
//    func checkAppVersion(completion: @escaping () -> Void) {
//        AppVersionManager.checkVersion { [weak self] isLatest in
//            self?.isLatestVersion = isLatest
//            completion()
//        }
//    }
    
    func logout() {
        let refreshToken = UserDefaults.standard.string(forKey: StringLiterals.UserDefaults.refreshToken) ?? ""
        ACService.shared.authService.postLogout(
            PostLogoutRequest(refreshToken: refreshToken)) { result in
                switch result {
                case .success:
                    print("⚙️Successfully logged out")
                    for key in UserDefaults.standard.dictionaryRepresentation().keys {
                        UserDefaults.standard.removeObject(forKey: key.description)
                    }
                    AmplitudeManager.shared.reset()
                    self.navigateToSplash()
                case .reIssueJWT:
                    self.handleReissue { [weak self] in
                        self?.logout()
                    }
                default:
                    print("⚙️Logout Failed")
                }
        }
    }
    
    private func navigateToSplash() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = SplashViewController()
        }
    }
    
}
