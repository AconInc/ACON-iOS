//
//  SettingType.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/13/25.
//

import UIKit

enum SettingType {
    
    enum Info: CaseIterable {
        case version
    }
    
    enum Policy: CaseIterable {
        case termsOfUse
        case privacyPolicy
    }
    
    enum PersonalSetting: CaseIterable {
        case onboarding
        case localVerification
    }
    
    enum Account: CaseIterable {
        case logout
        case withdrawal
    }
    
}


// MARK: - SettingCellModel Info

extension SettingType.Info {
    var title: String {
        switch self {
        case .version:
            return "현재 버전"
        }
    }
}

extension SettingType.Policy {
    var title: String {
        switch self {
        case .termsOfUse:
            return "이용약관"
        case .privacyPolicy:
            return "개인정보처리방침"
        }
    }
}

extension SettingType.PersonalSetting {
    var title: String {
        switch self {
        case .onboarding:
            return "취향탐색 다시하기"
        case .localVerification:
            return "동네 인증하기"
        }
    }
}

extension SettingType.Account {
    var title: String {
        switch self {
        case .logout:
            return "로그아웃하기"
        case .withdrawal:
            return "서비스 탈퇴"
        }
    }
}


// MARK: - Setting Section Info

extension SettingType {
    
    static let sectionTitles: [String] = [
        "버전 정보",
        "약관 및 정책",
        "서비스 설정",
        "로그아웃 / 탈퇴"
    ]
    
    static var allSections: [Int: Any] = [
        0: Info.allCases,
        1: Policy.allCases,
        2: PersonalSetting.allCases,
        3: Account.allCases
    ]
    
}
