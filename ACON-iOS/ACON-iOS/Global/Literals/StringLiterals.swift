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
        
        static let youAgreed = "가입을 진행할 경우, 아래의 정책에 대해 동의한 것으로 간주합니다."
        
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
        
        static let shallWeDropAcorns = "도토리를 떨어트려 리뷰를 남겨볼까요?"
        
        static let useAcornToReview = "도토리를 사용해 리뷰를 남겨주세요."
        
        static let acornsIHave = "보유한 도토리 수"
        
        static let reviewWithAcornsHere = "도토리로 리뷰남기기"
        
        static let finishedReview = "에 대한\n리뷰 작성을 완료했어요!"
        
        static let wishYouPreference = "당신의 취향이 가득 담긴 장소였길 바라요"
        
        static let closeAfterFiveSeconds = "5초 후 탭이 자동으로 닫힙니다."
        
        static let closeAfter = "초 후 탭이 자동으로 닫힙니다."
        
        static let ok = "확인"
        
        static let done = "완료"
        
        static let searchSpot = "가게명을 검색해주세요"
        
        static let noMatchingSpots = "앗... 검색결과가 없어요"
        
        static let addPlaceTitle = "현재 장소를 바로 등록할 수 있어요"
        
        static let addPlaceDescriptuon = "더욱 더 정확하게 추천이 가능해요"
        
        static let addPlaceButton = "5초만에 등록하러 가기"
        
        static let clickAcorn = "도토리를 선택해보세요"
        
        static let noAcorn = "도토리가 부족해요!"
        
    }
    
    enum SpotList {
        
        static let restaurant = "식당"
        
        static let cafe = "카페"
        
        static let matchingRate = "취향 일치율"
        
        static let bestChoice = "최고의 선택."
        
        static let footerText = "장소는 최대 6순위까지만 제공됩니다."
        
        static let emptySpotListErrorMessage = "앗! 일치하는 도토리 맛집이 없어요"
        
        static let unsupportedRegion = "서비스 불가지역"
        
        static let unsupportedRegionErrorMessage = "앗! 서비스 지원이 불가능한 지역에 있어요"
        
        static let walk = "도보 "
        
        static let minuteFindCourse = "분 길찾기"
        
        static let preparingImages = "장소 이미지를\n준비하고 있어요"
        
        static let needLoginToSeeMore = "더 많은 장소를 보기 위해\n로그인이 필요해요"
        
        static let loginInThreeSeconds = "3초 만에 로그인 하러 가기"
        
    }
    
    enum LocalVerification {
        
        static let title = "믿을 수 있는 리뷰를 위해\n지역인증이 필요해요"
        
        static let description = "더 정확한 로컬맛집을 추천해드릴 수 있어요"
        
        static let oneSecond = "1초만에 인증하기"
        
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
        
        static let pageTitle = "상세조건"
        
        static let restaurant = "음식점"
        
        static let cafe = "카페"
        
        static let kind = "종류"
        
        static let operatingHours = "운영시간"
        
        static let priceSection = "가격"
        
        static let goodPricePlace = "가성비 좋은 곳"
        
        static let reset = "초기화"
        
        static let showResults = "결과보기"
        
    }
    
    enum SpotDetail {
        
        static let isOpen = "영업중"
        
        static let isNotOpen = "영업전"
        
        static let menu = "메뉴"
        
        static let findCourse = "길 찾기"
        
        static let seeMore = "더보기"
        
        static let reportInfoError = "정보 오류 신고하기"
        
    }
    
    
    enum WebView {
        
        static let error = "에러"
        
        static let cantFindWebPage = "웹페이지를 찾을 수 없습니다."
        
        static let privacyPolicyLink = "https://bit.ly/acon개인정보처리방침"
        
        static let termsOfUseLink = "https://bit.ly/acon서비스이용약관"
        
        static let spotInfoErrorReportLink = "https://walla.my/survey/ekYLYwpJv2d0Eznnijla"
        
    }
    
    enum Network {
        
        static let accessToken = "accessToken"
        
        static let refreshToken = "refreshToken"
        
    }
    
    enum Onboarding {
        
        static let dislikeFoodTitle = "싫어하는 음식을\n알려줄 수 있나요?"
        
        static let dislikeFoodDescription = "싫어하는 음식은 설정에서 다시 수정할 수 있어요"
        
        static let allFood = "모든 음식을 잘 드시는 분이군요!"
        
        static let notAllFood = "확인했어요! 센스있게 추천해드릴게요"
        
        static let start = "시작하기"
        
    }
    
    enum DislikeTypes {
        
        static let dakbal = "닭발"
        
        static let hoeYukhoe = "회/육회"
        
        static let gopchang = "곱창/대창/막창"
        
        static let soondae = "순대/선지"
        
        static let yanggogi = "양고기"
        
        static let none = " "
        
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
