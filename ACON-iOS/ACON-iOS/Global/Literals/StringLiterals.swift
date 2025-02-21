//
//  StringLiterals.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/6/25.
//

import Foundation

enum StringLiterals {
    
    enum UserDefaults {
        
        static let accessToken = "accessToken"
        
        static let refreshToken = "refreshToken"
        
        static let hasVerifiedArea = "hasVerifiedArea"
        
    }
    
    enum Error {
        
        static let checkInternet = "인터넷 연결을 확인해주세요"
        
        static let reload = "다시 불러오기"
        
    }
    
    enum Login {
        
        static let googleLogin = "Google로 계속하기"
        
        static let appleLogin = "Apple로 계속하기"
        
        static let youAgreed = "가입을 진행할 경우,\n아래의 정책에 대해 동의한 것으로 간주합니다."
        
        static let termsOfUse = "이용약관"
        
        static let privacyPolicy = "개인정보처리방침"
        
        static let logoText = "매번 맛집을 찾느라\n고민중인 당신을 위한 지도"
        
    }
    
    enum LoginModal {
        
        static let title = "acon에 로그인"
        
        static let subTitle = "지금 당신의 위치에서\n가장 최고의 맛집을 추천받아보세요"
        
        static let successLogin = "로그인이 완료되었습니다."
        
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
        
        static let loginFailTitle = "로그인할 수 없음"
        
        static let loginFailMessage = "문제가 발생했습니다.\n나중에 다시 시도해주세요."
        
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
        
        static let next = "다음"
        
        static let shallWeDropAcorns = "도토리를 떨어트려\n리뷰를 남겨 볼까요?"
        
        static let useAcornToReview = "도토리를 사용해 리뷰를 남겨주세요."
        
        static let acornsIHave = "보유한 도토리 수"
        
        static let reviewWithAcornsHere = "도토리로 리뷰남기기"
        
        static let finishedReview = "가게명에 대한\n리뷰 작성을 완료했어요!"
        
        static let wishYouPreference = "당신의 취향이 가득 담긴 장소였길 바라요."
        
        static let closeAfterFiveSeconds = "5초 후 탭이 자동으로 닫힙니다."
        
        static let closeAfter = "초 후 탭이 자동으로 닫힙니다."
        
        static let ok = "확인"
        
        static let done = "완료"
        
        static let searchSpot = "가게명을 검색해주세요"
        
        static let noMatchingSpots = "앗! 일치하는 장소가 없어요."
        
        static let clickAcorn = "도토리를 터치해보세요"
        
        static let noAcorn = "도토리가 부족해요!"
        
    }
    
    enum SpotList {
        
        static let matchingRate = "취향 일치율"
        
        static let headerTitle = "지금, 나에게 딱 맞는 맛집이에요"
        
        static let footerText = "장소는 최대 6순위까지만 제공됩니다."
        
        static let failedToGetAddressNavTitle = "위치 확인 실패" // TODO: 라이팅 기획과 논의
        
        static let emptySpotListErrorMessage = "앗! 일치하는 도토리 맛집이 없어요"
        
        static let unsupportedRegionNavTitle = "서비스 불가지역"
        
        static let unsupportedRegionErrorMessage = "앗! 서비스 지원이 불가능한 지역에 있어요"
        
    }
    
    enum LocalVerification {
        
        static let needLocalVerification = "로컬 맛집 추천을 위해\n동네 인증이 필요해요"
        
        static let doLocalVerification = "자주 가는 동네로 지역 인증을 해보세요"
        
        static let new = "새로운"
        
        static let verifyLocal = " 나의 동네 인증하기"
        
        static let next = "다음"
        
        static let finishVerification = "인증완료"
        
        static let letsStart = "완료"
        
        static let locateOnMap = "지도에서 위치 확인하기"
        
        static let now = "이제 "
        
        static let localAcornTitle = "에\n로컬 도토리를 떨어트릴 수 있어요!"
        
        static let localAcornExplaination = "로컬 도토리는 로컬 맛집을 보증하는 도토리에요.\n만족스러운 식사 후 리뷰에 사용해보세요!"
        
        static let localAcorn = "로컬 도토리"
        
        static let plainAcorn = "일반 도토리"
        
        static let willYouDeleteThis = "을 삭제할까요?"
        
    }
    
    enum SpotListFilter {
        
        static let pageTitle = "상세 조건"
        
        static let restaurant = "음식점"
        
        static let cafe = "카페"
        
        static let spotSection = "방문 장소"
        
        static let companionSection = "함께 하는 사람"
        
        static let visitPurposeSection = "방문 목적"
        
        static let walkingSection = "도보 가능 거리"
        
        static let priceSection = "가격대"
        
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
    
    
    enum WebView {
        
        static let error = "에러"
        
        static let cantFindWebPage = "웹페이지를 찾을 수 없습니다."
        
        static let privacyPolicyLink = "https://bit.ly/acon개인정보처리방침"
        
        static let termsOfUseLink = "https://bit.ly/acon서비스이용약관"
        
    }
    
    enum Network {
        
        static let accessToken = "accessToken"
        
        static let refreshToken = "refreshToken"
        
    }
    
    
    enum DislikeTypes {
        
        static let dakbal = "닭발"
        
        static let hoeYukhoe = "회/육회"
        
        static let gopchang = "곱창/대창/막창"
        
        static let soondae = "순대/선지"
        
        static let yanggogi = "양고기"
        
        static let none = " "
        
    }
    
    enum FavoriteSpotRankTypes {
        
        static let mood = "분위기가 감각적인"
        
        static let new = "새로운 음식의 경험"
        
        static let quality = "합리적인 가격과 양"
        
        static let special = "특별한 날, 고급스러운"
        
    }
    
    enum FavoriteSpotTypes {
        
        static let restaurant = "음식점"
        
        static let cafe = "카페"
        
    }
    
    enum FavoriteSpotStyles {
        
        static let nopo = "빈티지"
        
        static let modern = "모던"
        
    }
    
    enum FavoriteCuisineTypes {
        
        static let korean = "한식"
        
        static let western = "양식"
        
        static let chinese = "중식"
        
        static let japanese = "일식"
        
        static let koreanStreet = "분식"
        
        static let asian = "아시안"
        
    }
    
    enum OnboardingType {
        
        static let progressNumberList = ["01", "02", "03", "04", "05"]
        
        static let progressTitleList = [
            "싫어하는 음식을 선택해주세요",
            "선호 음식 Top3까지 순위를 매겨주세요.",
            "자주 가는 곳이 어디인가요?",
            "어떤 분위기의 공간이 좋으세요?",
            "선호하는 맛집 스타일의\n순위를 매겨주세요."
        ]
        
    }
    
    enum Profile {
        
        static let profilePageTitle = "프로필"
        
        static let profileEditPageTitle = "프로필 편집"
        
        static let profileEditButton = "프로필 수정하기"
        
        static let needLogin = "로그인이 필요해요"
        
        static let doubleQuestionMarks = "??"
        
        static let notVerified = "미인증"
        
        static let acornPossession = "보유한 도토리 수"
        
        static let myVerifiedArea = "나의 인증 동네"
        
        static let neccessaryStarWithSpace = " *"
        
        static let nickname = "닉네임"
        
        static let birthDate = "생년월일"
        
        static let verifiedArea = "인증 동네"
        
        static let nicknamePlaceholder = "16자 이내 영문, 한글, 숫자, . , _ 만 사용가능"
        
        static let birthDatePlaceholder = "ex) 2025.01.01"
        
        static let addVerifiedArea = "동네 추가하기"
        
        static let save = "저장"
        
    }
    
    enum Album {
        
        static let choose = "선택"
        
        static let done = "완료"
        
    }
    
    enum Withdrawal {
        
        static let title = "서비스 탈퇴"
        
        static let reasonTitle = "이별의 순간이 왔어요...\n떠나시려는 이유가 있을까요?"
        
        static let reasonDescription = "어떤 부분이 마음에 들지 않았는지 알려주시면,\n더 좋은 acon을 만드는데 도움이 됩니다."
        
        static let optionLackOfRestaurants = "등록된 맛집이 너무 적어요"
        
        static let optionUnsatisfiedRecommendation = "추천 결과가 만족스럽지 않아요"
        
        static let optionFakeReviews = "거짓 리뷰를 봤어요"
        
        static let optionOthers = "기타"
        
        static let submit = "제출하기"
        
        static let withdrawalReason = "탈퇴하려는 이유를 적어주세요"
    }
    
    enum WithdrawalConfirmation {
        
        static let title = "지금 탈퇴를 진행할까요?"
        
        static let description = "지금 탈퇴를 진행하면 취향정보, 리뷰 등\n모든 데이터는 영구적으로 삭제되며 복구할 수 없어요"
        
        static let cancelButtonTitle = "취소하기"
        
        static let confirmButtonTitle = "아쉽지만 탈퇴하기"
    }
    
}
