//
//  TokenLogger.swift
//  ACON-iOS
//
//  Created by 김유림 on 10/11/25.
//

import Foundation

final class TokenLogger {

    static let shared = TokenLogger()
    private init() {}

    private let maxLogCount = 100


    // MARK: - Public

    func log(_ event: TokenLogEvent) {
        var logs = loadLogs()
        let timestamp = formattedDate()
        let entry = "[\(timestamp)] \(event.message)"
        logs.append(entry)

        // NOTE: 오래된 로그 제거
        if logs.count > maxLogCount {
            logs = Array(logs.suffix(maxLogCount))
        }

        saveLogs(logs)
        print("🪵 TokenLog:", entry)
    }

    func loadLogs() -> [String] {
        UserDefaultsUtils.get([String].self, forKey: .tokenLogs) ?? []
    }

    func clearLogs() {
        UserDefaultsUtils.remove(forKey: .tokenLogs)
    }


    // MARK: - Private

    private func saveLogs(_ logs: [String]) {
        UserDefaultsUtils.set(logs, forKey: .tokenLogs)
    }

    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }

}


// MARK: - Enum

enum TokenLogEvent {

    // 상태 로그
    case valid
    case noToken
    case tokenExpired

    // 액션 로그
    case saved(tokenPrefix: String)
    case cleared
    case refreshSucceeded(tokenPrefix: String)
    case refreshFailed(error: String?)

    var message: String {
        switch self {
        // NOTE: 상태 로그 (스플래시 진입 시점 토큰 상태)
        case .valid:                                                 /// 액세스토큰 유효 (-> 자동로그인)
            return "✅ has valid access token"
        case .noToken:                                               /// 토큰 없음 (로그아웃 상태)
            return "⚠️ no token found"
        case .tokenExpired:                                          /// 액세스토큰 만료
            return "⏱️ access token expired — requesting refresh"

        // NOTE: 액션 로그
        case .saved(let tokenPrefix):                               /// 로그인 성공 시
            return "💾 saved new access token (prefix: \(tokenPrefix))"
        case .cleared:                                              /// 로그아웃/탈퇴 시
            return "🗑️ Access token cleared"
        case .refreshSucceeded(let tokenPrefix):                    /// 액세스토큰 갱신 성공 시
            return "💾 token refresh succeeded (prefix: \(tokenPrefix))"
        case .refreshFailed(let error):                             /// 액세스토큰 갱신 실패 시
            return "❌ Token refresh failed: \(error ?? "unknown error")"
        }
    }

}
