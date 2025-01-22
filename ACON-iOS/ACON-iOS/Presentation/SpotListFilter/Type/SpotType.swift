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
    
    var walkingTimeDefault: Int {
        return 50
    }
    
    var priceDefault: Int {
        switch self {
        case .restaurant: return 25
        case .cafe: return 50
        }
    }
    
    
    enum FilterCategoryType: CaseIterable {
        
        case restaurantFeature, cafeFeature, companion, visitPurpose
        
        var serverKey: String {
            switch self {
            case .restaurantFeature: return "RESTAURANT_FEATURE"
            case .cafeFeature: return "CAFE_FEATURE"
            case .companion: return "COMPANION_TYPE"
            case .visitPurpose: return "VISIT_PURPOSE"
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
            case .excludeFranchise: return "EXCLUDE_FRANCHISE 제외"
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
    
    enum CompanionType: CaseIterable {
        
        case family, date, friend, alone, group
        
        var text: String {
            switch self {
            case .family: return "가족"
            case .date: return "연인"
            case .friend: return "친구"
            case .alone: return "혼자"
            case .group: return "단체"
            }
        }
        
        var serverKey: String {
            switch self {
            case .family: return "FAMILY"
            case .date: return "DATE"
            case .friend: return "FRIEND"
            case .alone: return "ALONE"
            case .group: return "GROUP"
            }
        }
        
    }
    
    enum VisitPurposeType: CaseIterable {
        
        case meeting, study
        
        var text: String {
            switch self {
            case .meeting: return "만남용"
            case .study: return "공부용"
            }
        }
        
        var serverKey: String {
            switch self {
            case .meeting: return "MEETING"
            case .study: return "STUDY"
            }
        }
        
    }
    
}
