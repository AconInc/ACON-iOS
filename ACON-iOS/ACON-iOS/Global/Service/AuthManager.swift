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

    // NOTE: access token 갱신 간격: 3시간 (10,800초)
    private let refreshInterval: TimeInterval = 3 * 60 * 60

    var hasToken: Bool {
        return UserDefaultsUtils.get(String.self, forKey: .accessToken) != nil
    }

    var hasVerifiedArea: Bool {
        return UserDefaultsUtils.get(Bool.self, forKey: .hasVerifiedArea) ?? false
    }

    var hasPreference: Bool {
        return UserDefaultsUtils.get(Bool.self, forKey: .hasPreference) ?? false
    }

    var hasSeenTutorial: Bool {
        return UserDefaultsUtils.get(Bool.self, forKey: .hasSeenTutorial) ?? false
    }

    var hasSeenLocalVerification: Bool {
        return UserDefaultsUtils.get(Bool.self, forKey: .hasSeenLocalVerification) ?? false
    }

    var hasSeenPreference: Bool {
        return UserDefaultsUtils.get(Bool.self, forKey: .hasSeenPreference) ?? false
    }

    func handleTokenRefresh() async throws -> Bool {
        let refreshToken = UserDefaultsUtils.get(String.self, forKey: .refreshToken) ?? ""
        return try await withCheckedThrowingContinuation { continuation in
            ACService.shared.authService.postReissue(PostReissueRequest(refreshToken: refreshToken)) { response in
                switch response {
                case .success(let data):
                    print("❄️ token refreshed success")
                    UserDefaultsUtils.set(data.accessToken, forKey: .accessToken)
                    UserDefaultsUtils.set(data.refreshToken, forKey: .refreshToken)
                    AuthManager.shared.updateLastTokenRefreshDate()
                    TokenLogger.shared.log(.refreshSucceeded(tokenPrefix: String(data.accessToken.prefix(10))))
                    continuation.resume(returning: true)
                case .requestErr(let error):
                    if error.code == 40088 {
                        print("❄️ remove token")
                        UserDefaultsUtils.removeTokens()
                        TokenLogger.shared.log(.refreshFailed(error: error.localizedDescription))
                        continuation.resume(returning: false)
                    }
                default:
                    TokenLogger.shared.log(.refreshFailed(error: "unknown"))
                    continuation.resume(returning: false)
                }
            }
        }
    }

    func updateLastTokenRefreshDate() {
        let now = Date()
        UserDefaultsUtils.set(now, forKey: .lastTokenRefreshDate)
    }

    // NOTE: access token이 만료되었으면 true
    func needsTokenRefresh() -> Bool {
        guard let lastRefresh = UserDefaultsUtils.get(Date.self, forKey: .lastTokenRefreshDate) else {
            return true
        }
        let elapsed = Date().timeIntervalSince(lastRefresh)
        print("❄️ token elapsed: \(elapsed) / \(refreshInterval) seconds")
        TokenLogger.shared.log(elapsed >= refreshInterval ? .tokenExpired : .valid)
        return elapsed >= refreshInterval
    }

}
