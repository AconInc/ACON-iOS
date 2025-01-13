//
//  SpotType.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import Foundation

enum SpotType {
    
    case restaurant, cafe
    
    var text: String {
        switch self {
        case .restaurant: return "음식점"
        case .cafe: return "카페"
        }
    }
    
}

enum RestaurantFeature {
    
    case korean, western, chinese, japanese, snack, asian, bar, excludeFranchise
    
    var text: String {
        switch self {
        case .korean: return "한식"
        case .western: return "양식"
        case .chinese: return "중식"
        case .japanese: return "일식"
        case .snack: return "간식"
        case .asian: return "아시안"
        case .bar: return "술/bar"
        case .excludeFranchise: return "프랜차이즈 제외"
        }
    }
    
}

enum CafeFeature {
    
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
    
}

enum CompanionType {
    
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
    
}

enum VisitPurpose {
    
    case meeting, study
    
    var text: String {
        switch self {
        case .meeting: return "만남용"
        case .study: return "공부용"
        }
    }
    
}
