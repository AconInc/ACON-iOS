//
//  UserDefaultsManager.swift
//  ACON-iOS
//
//  Created by 김유림 on 9/12/25.
//

import Foundation

struct UserDefaultsManager {

    enum Keys: String, CaseIterable {
        case accessToken
        case refreshToken

        case hasVerifiedArea
        case hasPreference

        case hasSeenTutorial // NOTE: 초기화되면 안 됨
        case hasSeenVerifiedAreaOnboarding // NOTE: 초기화되면 안 됨
        case hasSeenPreferenceOnboarding // NOTE: 초기화되면 안 됨

        case lastTokenRefreshDate
        case lastLocalVerificationAlertDate
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
    ///   - `hasSeenTutorial` 키는 유지됩니다.
    static func resetAppUserDefaults() {
        for key in Keys.allCases {
            if key == .hasSeenTutorial
                || key == .hasSeenVerifiedAreaOnboarding
                || key == .hasSeenPreferenceOnboarding { continue }

            remove(forKey: key)
        }
    }

    static func removeTokens() {
        [Keys.accessToken, Keys.refreshToken].forEach {
            remove(forKey: $0)
        }
    }

}
