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
        case lastTokenRefreshDate
        case hasVerifiedArea
        case hasPreference
        case lastLocalVerificationAlertTime
        case hasSeenTutorial // NOTE: 초기화되면 안 됨
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
    
    // NOTE: hasSeenTutorial을 제외하고 초기화
    static func removeAll() {
        for key in Keys.allCases {
            if key == .hasSeenTutorial { continue }
            remove(forKey: key)
        }
    }

    static func removeTokens() {
        [Keys.accessToken, Keys.refreshToken].forEach {
            remove(forKey: $0)
        }
    }

}
