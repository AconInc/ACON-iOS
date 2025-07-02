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

    var text: String {
        switch self {
        case .none: return ""
        case .nicknameMissing: return "닉네임을 입력해주세요."
        case .invalidChar: return "영어, 숫자, 밑줄 및 마침표만 사용 가능해요."
        case .nicknameTaken: return "이미 사용중인 닉네임이에요."
        case .nicknameOK: return "사용할 수 있는 닉네임이에요."
        case .invalidDate: return "정확한 생년월일을 입력해주세요."
        }
    }

}
