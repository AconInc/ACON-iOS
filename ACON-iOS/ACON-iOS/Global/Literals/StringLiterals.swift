//
//  StringLiterals.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/6/25.
//

import Foundation

enum StringLiterals {
    
    enum Login {
        
        static let googleLogin = "Google로 계속하기"
        
        static let appleLogin = "Apple로 계속하기"
        
        static let youAgreed = "가입을 진행할 경우, 아래의 정책에 대해 동의한 것으로 간주합니다."
        
        static let termsOfUse = "이용약관"
        
        static let privacyPolicy = "개인정보처리방침"
        
    }

    enum TabBar {
        
        static let spotList = "장소"
        
        static let upload = "업로드"
        
        static let profile = "프로필"
        
    }
    
    enum Alert {
        
        static let ok = "확인"
        
        static let notLocatedTitle = "위치 인식 실패"
        
        static let notLocatedMessage = "문제가 발생했습니다.\n나중에 다시 시도해주세요."
        
        static let gpsDeprecatedTitle = "위치인식 실패"
        
        static let gpsDeprecatedMessage = "기기에서 위치서비스가 비활성화되어 있습니다.\n설정에서 활성화상태로 변경해주세요."
        
        static let gpsDeniedTitle = "'acon'에 대한 위치접근 권한이 없습니다."
        
        static let gpsDeniedMessage = "설정에서 정확한 위치 권한을 허용해주세요."
        
    }
    
}
