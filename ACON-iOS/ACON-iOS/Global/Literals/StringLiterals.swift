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
        
        static let middleDetent = "acMiddleDetent"
        
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
        
        static let footerText = "장소는 최대 6순위까지만 제공됩니다."
        
    }
    
    enum LocalVerification {

         static let needLocalVerification = "로컬 맛집 추천을 위해\n지역 인증이 필요해요."

         static let doLocalVerification = "자주 가는 동네로 지역 인증을 해보세요"

         static let new = "새로운"

         static let verifyLocal = " 나의 동네 인증하기"

         static let next = "다음"

         static let finishVerification = "인증완료"

         static let letsStart = "시작하기"

         static let locateOnMap = "지도에서 위치 확인하기"

         static let now = "이제 "

         static let localAcornTitle = "에\n로컬 도토리를 떨어트릴 수 있어요!"

         static let localAcornExplaination = "로컬 도토리는 로컬 맛집을 보증하는 도토리에요.\n만족스러운 식사 후 리뷰에 사용해보세요!"

         static let localAcorn = "로컬 도토리"

         static let plainAcorn = "일반 도토리"
     }
    
    enum SpotListFilter {
        
        static let pageTitle = "조건 설정"
        
        static let restaurant = "음식점"
        
        static let cafe = "카페"
        
        static let spotSection = "방문 장소"
        
        static let companionSection = "함께 하는 사람"
        
        static let visitPurposeSection = "방문 목적"
        
        static let walkingSection = "도보 가능 거리"
        
        static let priceSection = "가격대"
        
        static let walkingTimes = ["5분 이내", "10분", "15분", "20분", "20분 이상"]
        
        static let restaurantPrices = ["5천원 이하", "1만원", "3만원", "5만원", "5만원 이상"]
        
        static let cafePrices = ["3천원 이하", "5천원", "1만원 이상"]
    }
    
    enum Analyzing {
        
        static let analyzing = "회원님의 취향을 \n빠르게 분석하고 있어요"
        
        static let analyzingAfter = "분석이 완료되었어요\n추천 맛집을 보여드릴게요!"
        
    }
    
    enum SpotDetail {
        
        static let isOpen = "영업중"
        
        static let isNotOpen = "영업전"
        
        static let menu = "메뉴"
        
        static let findCourse = "길 찾기"
        
    }
    
}
