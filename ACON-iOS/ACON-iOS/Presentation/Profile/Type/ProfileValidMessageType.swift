//
//  ProfileValidMessageType.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import Foundation

enum ProfileValidMessageType {
    
    case none
    case nicknameMissing, invalidChar, nicknameTaken, nicknameOK
    case invalidDate
    case areaMissing
    
    var texts: [String] {
        switch self {
        case .none: return [""]
        case .nicknameMissing: return ["닉네임을 입력해주세요"]
        case .invalidChar: return [
            "._ 이외의 특수기호는 사용할 수 없어요",
            "한국어, 영어 이외의 언어는 사용할 수 없어요"
        ]
        case .nicknameTaken: return ["이미 사용중인 닉네임이에요"]
        case .nicknameOK: return ["사용할 수 있는 닉네임이에요"]
        case .invalidDate: return ["정확한 생년월일을 적어주세요"]
        case .areaMissing: return ["로컬도토리를 위해 최소 1개의 동네를 인증해주세요"]
        }
    }
    
}
