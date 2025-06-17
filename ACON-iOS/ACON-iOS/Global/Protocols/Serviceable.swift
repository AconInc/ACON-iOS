//
//  Serviceable.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/17/25.
//

import UIKit

protocol Serviceable: AnyObject { }


// MARK: - Reissue

extension Serviceable {
    
    func handleReissue(retryAction: @escaping () -> Void) {
        Task {
            do {
                let success = try await AuthManager.shared.handleTokenRefresh()
                DispatchQueue.main.async {
                    if success {
                        print("❄️ 기존 서버통신 다시 성공")
                        retryAction()
                    } else {
                        for key in UserDefaults.standard.dictionaryRepresentation().keys {
                            UserDefaults.standard.removeObject(forKey: key.description)
                        }
                        self.navigateToSplash()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    for key in UserDefaults.standard.dictionaryRepresentation().keys {
                        UserDefaults.standard.removeObject(forKey: key.description)
                    }
                    self.navigateToSplash()
                }
            }
        }
    }
    
    private func navigateToSplash() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = SplashViewController()
        }
    }
    
}
