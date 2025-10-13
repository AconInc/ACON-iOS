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
        // 상태 로그
        case .valid:
            return "✅ has valid access token"
        case .noToken:
            return "⚠️ no token found"
        case .tokenExpired:
            return "⏱️ access token expired — requesting refresh"

        // 액션 로그
        case .saved(let tokenPrefix):
            return "💾 saved new access token (prefix: \(tokenPrefix))"
        case .cleared:
            return "🗑️ Access token cleared"
        case .refreshSucceeded(let tokenPrefix):
            return "💾 token refresh succeeded (prefix: \(tokenPrefix))"
        case .refreshFailed(let error):
            return "❌ Token refresh failed: \(error ?? "unknown error")"
        }
    }

}
