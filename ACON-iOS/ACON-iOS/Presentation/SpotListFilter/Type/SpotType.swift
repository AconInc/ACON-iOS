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
        case .cafe: return 2
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
        
        case korean, chinese, japanese, western, asian, fusion, koreanStreet, buffet, bar
        
        var text: String {
            switch self {
            case .korean: return "한식"
            case .chinese: return "중식"
            case .japanese: return "일식"
            case .western: return "양식"
            case .asian: return "아시안"
            case .fusion: return "퓨전"
            case .koreanStreet: return "분식"
            case .buffet: return "뷔페"
            case .bar: return "술/bar"
            }
        }
        
        var serverKey: String {
            switch self {
            case .korean: return "KOREAN"
            case .chinese: return "CHINESE"
            case .japanese: return "JAPANESE"
            case .western: return "WESTERN"
            case .asian: return "ASIAN"
            case .fusion: return "FUSION"
            case .koreanStreet: return "KOREAN_STREET"
            case .buffet: return "BUFFET"
            case .bar: return "BAR"
            }
        }
        
    }
    
    enum CafeFeatureType: CaseIterable {
        
        case goodForWork, excludeFranchise
        
        var text: String {
            switch self {
            case .goodForWork: return "작업하기 좋은 곳"
            case .excludeFranchise: return "프랜차이즈 제외"
            }
        }
        
        var serverKey: String {
            switch self {
            case .goodForWork: return "GOOD_FOR_WORK" // TODO: 명세 나오면 수정
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
