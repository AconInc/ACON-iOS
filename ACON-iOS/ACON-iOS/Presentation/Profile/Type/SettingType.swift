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
            return StringLiterals.Setting.version
        }
    }
}

extension SettingType.Policy {
    var title: String {
        switch self {
        case .termsOfUse:
            return StringLiterals.Setting.termsOfUse
        case .privacyPolicy:
            return StringLiterals.Setting.privacyPolicy
        }
    }
}

extension SettingType.PersonalSetting {
    var title: String {
        switch self {
        case .onboarding:
            return StringLiterals.Setting.onboarding
        case .localVerification:
            return StringLiterals.Setting.localVerification
        }
    }
}

extension SettingType.Account {
    var title: String {
        switch self {
        case .logout:
            return StringLiterals.Setting.logout
        case .withdrawal:
            return StringLiterals.Setting.withdrawal
        }
    }
}


// MARK: - Setting Section Info

extension SettingType {
    
    static let sectionTitles: [String] = [
        StringLiterals.Setting.versionInfo,
        StringLiterals.Setting.policy,
        StringLiterals.Setting.serviceSettings,
        StringLiterals.Setting.accountManagement
    ]
    
    static var allSections: [Int: Any] = [
        0: Info.allCases,
        1: Policy.allCases,
        2: PersonalSetting.allCases,
        3: Account.allCases
    ]
    
}
