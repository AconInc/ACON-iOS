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

    // NOTE: access token 갱신 간격: 2시간 30분(9000초)
    private let refreshInterval: TimeInterval = 2.5 * 60 * 60

    var hasToken: Bool {
        return UserDefaultsManager.get(String.self, forKey: .accessToken) != nil
    }

    var hasVerifiedArea: Bool {
        return UserDefaultsManager.get(Bool.self, forKey: .hasVerifiedArea) ?? false
    }

    var hasPreference: Bool {
        return UserDefaultsManager.get(Bool.self, forKey: .hasPreference) ?? false
    }

    var hasSeenTutorial: Bool {
        return UserDefaultsManager.get(Bool.self, forKey: .hasSeenTutorial) ?? false
    }

    func handleTokenRefresh() async throws -> Bool {
        let refreshToken = UserDefaultsManager.get(String.self, forKey: .refreshToken) ?? ""
        return try await withCheckedThrowingContinuation { continuation in
            ACService.shared.authService.postReissue(PostReissueRequest(refreshToken: refreshToken)) { response in
                switch response {
                case .success(let data):
                    print("❄️ token refreshed success")
                    UserDefaultsManager.set(data.accessToken, forKey: .accessToken)
                    UserDefaultsManager.set(data.refreshToken, forKey: .refreshToken)
                    AuthManager.shared.updateLastTokenRefreshDate()
                    continuation.resume(returning: true)
                case .requestErr(let error):
                    if error.code == 40088 {
                        print("❄️ remove token")
                        UserDefaultsManager.removeTokens()
                        continuation.resume(returning: false)
                    }
                default:
                    continuation.resume(returning: false)
                }
            }
        }
    }

    func updateLastTokenRefreshDate() {
        let now = Date()
        UserDefaultsManager.set(now, forKey: .lastTokenRefreshDate)
    }

    // NOTE: access token 유효시간이 30분 미만이면 true
    func needsTokenRefresh() -> Bool {
        guard let lastRefresh = UserDefaultsManager.get(Date.self, forKey: .lastTokenRefreshDate) else {
            return true
        }
        let elapsed = Date().timeIntervalSince(lastRefresh)
        print("❄️ token elapsed: \(elapsed) / \(refreshInterval) seconds")
        return elapsed >= refreshInterval
    }

}
