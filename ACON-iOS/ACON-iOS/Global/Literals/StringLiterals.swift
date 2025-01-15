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
    
    enum SheetUtils {
        
        static let shortDetent = "acShortDetent"
        
        static let longDetent = "acLongDetent"
        
    }
    
    enum Upload {
        
        static let upload = "업로드"
        
        static let spotUpload = "장소 등록"
        
        static let spotUpload2 = "장소등록"
        
        static let uploadSpotName = "가게명 등록하기"
        
        static let dropAcornsHere = "이곳에 도토리 남기기"
        
        static let shallWeDropAcorns = "이제 도토리를\n떨어트려볼까요?"

        static let useAcornToReview = "도토리를 사용해 리뷰를 남겨주세요."
        
        static let acornsIHave = "보유한 도토리 수"
        
        static let reviewWithAcornsHere = "도토리로 리뷰남기기"
        
        static let finishedReview = "가게명에 대한\n리뷰 작성을 완료했어요!"
        
        static let wishYouPreference = "당신의 취향이 가득 담긴 장소였길 바라요."
        
        static let closeAfterFiveSeconds = "5초 후 탭이 자동으로 닫힙니다."
        
        static let ok = "확인"
        
        static let done = "완료"
        
        static let searchSpot = "가게명을 검색해주세요"
        
        static let noMatchingSpots = "앗! 일치하는 장소가 없어요."
        
    }
    
    enum SpotList {
        
        static let matchingRate = "취향 일치율"
        
        static let headerTitle = "지금, 나에게 딱 맞는 맛집이에요"
        
    }
    
}
