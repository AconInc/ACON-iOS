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
    }
    
    enum Account: CaseIterable {
        case logout
        case withdrawal
    }
    
}


// MARK: - SettingCellModel Info

extension SettingType.Info {
    var cellModel: SettingCellModel {
        switch self {
        case .version:
            return SettingCellModel(
                image: UIImage.icProfileVersion,
                title: "현재 버전"
            )
        }
    }
}

extension SettingType.Policy {
    var cellModel: SettingCellModel {
        switch self {
        case .termsOfUse:
            return SettingCellModel(
                image: UIImage.icProfileTermsofuse,
                title: "이용약관"
            )
        case .privacyPolicy:
            return SettingCellModel(
                image: UIImage.icProfilePrivacypolicy,
                title: "개인정보처리방침"
            )
        }
    }
}

extension SettingType.PersonalSetting {
    var cellModel: SettingCellModel {
        switch self {
        case .onboarding:
            return SettingCellModel(
                image: UIImage.icProfileGoOnboarding,
                title: "취향탐색 다시하기"
            )
        }
    }
}

extension SettingType.Account {
    var cellModel: SettingCellModel {
        switch self {
        case .logout:
            return SettingCellModel(
                image: UIImage.icProfileLogout,
                title: "로그아웃하기"
            )
        case .withdrawal:
            return SettingCellModel(
                image: UIImage.icProfileWithdraw,
                title: "서비스 탈퇴"
            )
        }
    }
}


// MARK: - Setting Section Info

extension SettingType {
    
    static func getSectionTitle(_ section: Int) -> String {
        switch section {
        case 0: return "버전 정보"
        case 1: return "약관 및 정책"
        case 2: return "서비스 설정"
        case 3: return "로그아웃 / 탈퇴"
        default: return ""
        }
    }
    
    static var allSections: [Int: Any] = [
        0: Info.allCases,
        1: Policy.allCases,
        2: PersonalSetting.allCases,
        3: Account.allCases
    ]
    
}
