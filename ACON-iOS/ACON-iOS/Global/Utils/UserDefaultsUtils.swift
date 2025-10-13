//
//  UserDefaultsUtils.swift
//  ACON-iOS
//
//  Created by 김유림 on 9/12/25.
//

import Foundation

struct UserDefaultsUtils {

    enum Keys: String, CaseIterable {
        case accessToken
        case refreshToken

        case hasVerifiedArea
        case hasPreference

        case hasSeenTutorial // NOTE: 초기화되면 안 됨
        case hasSeenLocalVerification // NOTE: 초기화되면 안 됨
        case hasSeenPreference // NOTE: 초기화되면 안 됨

        case lastTokenRefreshDate
        case lastLocalVerificationAlertDate

        case tokenLogs
    }


    // MARK: - 생성/수정

    static func set<T>(_ value: T, forKey key: Keys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }


    // MARK: - 읽기

    static func get<T>(_ type: T.Type, forKey key: Keys) -> T? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? T
    }


    // MARK: - 삭제

    static func remove(forKey key: Keys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }

    /// 앱에서 정의한 UserDefaults를 초기화합니다.
    /// - Note:
    ///   - 시스템에서 사용하는 UserDefaults 키는 영향을 받지 않습니다.
    ///   - 1회 노출과 관련된 키는 유지됩니다.
    ///     - `hasSeenTutorial`
    ///     - `hasSeenLocalVerification`
    ///     - `hasSeenPreference`
    static func resetAppUserDefaults() {
        for key in Keys.allCases {
            if key == .hasSeenTutorial
                || key == .hasSeenLocalVerification
                || key == .hasSeenPreference { continue }

            remove(forKey: key)
        }
        TokenLogger.shared.log(.cleared)
    }

    static func removeTokens() {
        [Keys.accessToken, Keys.refreshToken].forEach {
            remove(forKey: $0)
        }
        TokenLogger.shared.log(.cleared)
    }

}
