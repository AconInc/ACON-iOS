//
//  SpotType.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import Foundation

enum SpotType {
    
    // MARK: - 장소 종류
    
    case restaurant, cafe
    
    var text: String {
        switch self {
        case .restaurant: return "음식점"
        case .cafe: return "카페"
        }
    }
    
    var serverKey: String {
        switch self {
        case .restaurant: return "RESTAURANT"
        case .cafe: return "CAFE"
        }
    }

    var firstLineCount: Int { // TODO: 관련 코드 수정
        switch self {
        case .restaurant: return 5
        case .cafe: return 4
        }
    }


    // MARK: - 필터 조건 타입
    
    enum FilterCategoryType: CaseIterable {
        
        case restaurantFeature, cafeFeature
        
        var serverKey: String {
            switch self {
            case .restaurantFeature: return "RESTAURANT_FEATURE"
            case .cafeFeature: return "CAFE_FEATURE"
            }
        }
        
    }


    // MARK: - 장소 상세 조건
    
    enum RestaurantFeatureType: CaseIterable {
        
        case korean, western, chinese, japanese, koreanStreet, asian, bar, excludeFranchise
        
        var text: String {
            switch self {
            case .korean: return "한식"
            case .western: return "양식"
            case .chinese: return "중식"
            case .japanese: return "일식"
            case .koreanStreet: return "간식"
            case .asian: return "아시안"
            case .bar: return "술/bar"
            case .excludeFranchise: return "프랜차이즈 제외"
            }
        }
        
        var serverKey: String {
            switch self {
            case .korean: return "KOREAN"
            case .western: return "WESTERN"
            case .chinese: return "CHINESE"
            case .japanese: return "JAPANESE"
            case .koreanStreet: return "KOREAN_STREET"
            case .asian: return "ASIAN"
            case .bar: return "BAR"
            case .excludeFranchise: return "EXCLUDE_FRANCHISE"
            }
        }
        
    }
    
    enum CafeFeatureType: CaseIterable {
        
        case large, goodView, dessert, terace, excludeFranchise
        
        var text: String {
            switch self {
            case .large: return "대형"
            case .goodView: return "뷰 좋은 곳"
            case .dessert: return "디저트"
            case .terace: return "테라스"
            case .excludeFranchise: return "프랜차이즈 제외"
            }
        }
        
        var serverKey: String {
            switch self {
            case .large: return "LARGE"
            case .goodView: return "GOOD_VIEW"
            case .dessert: return "DESSERT"
            case .terace: return "TERRACE"
            case .excludeFranchise: return "EXCLUDE_FRANCHISE"
            }
        }
        
    }
    
    enum OperatingHours: CaseIterable {
        
        case overMidnight, overTenPM
        
        var text: String {
            switch self {
            case .overMidnight: return "밤 12시 이후"
            case .overTenPM: return "밤 10시 이후"
            }
        }
        
        // TODO: 명세 나오면 수정하기
        var serverKey: String {
            switch self {
            case .overMidnight: return "MIDNIGHT"
            case .overTenPM: return "TEN_PM"
            }
        }
    }
    
}
