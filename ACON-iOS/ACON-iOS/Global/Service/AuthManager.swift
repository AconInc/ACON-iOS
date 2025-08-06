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
    
    var hasPreference: Bool {
        get {
            UserDefaults.standard.bool(forKey: StringLiterals.UserDefaults.hasPreference)
        }
    }
    
    func removeToken() {
        [StringLiterals.UserDefaults.accessToken,
         StringLiterals.UserDefaults.refreshToken].forEach { UserDefaults.standard.removeObject(forKey: $0)
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
                case .requestErr(let error):
                    if error.code == 40088 {
                        self.removeToken()
                        NavigationUtils.navigateToSplash()
                    }
                default:
                    continuation.resume(returning: false)
                }
            }
        }
    }
}
