//
//  AuthManager.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/23/25.
//

import UIKit

final class AuthManager {
    static let shared = AuthManager()
    private init() {}
    
    var hasToken: Bool {
        get {
            UserDefaults.standard.string(forKey: StringLiterals.UserDefaults.accessToken) != nil
        }
    }
    
    var hasVerifiedArea: Bool {
        get {
            UserDefaults.standard.bool(forKey: StringLiterals.UserDefaults.hasVerifiedArea)
        }
    }

    func handleTokenRefresh() async throws -> Bool {
        let refreshToken = UserDefaults.standard.string(forKey: StringLiterals.UserDefaults.refreshToken) ?? ""
        return try await withCheckedThrowingContinuation { continuation in
            ACService.shared.authService.postReissue(PostReissueRequest(refreshToken: refreshToken)) { response in
                switch response {
                case .success(let data):
                    print("❄️ token refreshed success")
                    UserDefaults.standard.set(data.accessToken, forKey: StringLiterals.UserDefaults.accessToken)
                    UserDefaults.standard.set(data.refreshToken, forKey: StringLiterals.UserDefaults.refreshToken)
                    continuation.resume(returning: true)
                default:
                    continuation.resume(returning: false)
                }
            }
        }
    }
}


// MARK: - Servicable

protocol Serviceable: AnyObject { }

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
