//
//  SpotListFilterModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import Foundation

struct SpotListFilterModel {
    
    // TODO: Type에 포함시키는 방향으로 수정
    struct RestaurantFeature {
        
        static let firstLine: [SpotType.RestaurantFeatureType] = [
            .korean, .western, .chinese, .japanese, .snack
        ]
        
        static let secondLine: [SpotType.RestaurantFeatureType] = [
            .asian, .bar, .excludeFranchise
        ]
        
    }
    
    struct CafeFeature {
        
        static let firstLine: [SpotType.CafeFeatureType] = [
            .large, .goodView, .dessert, .terace
        ]
        
        static let secondLine: [SpotType.CafeFeatureType] = [
            .excludeFranchise
        ]
        
    }
    
    struct Companion {
        
        static let firstLine: [SpotType.CompanionType] = [
            .family, .date, .friend, .alone, .group
        ]
        
        static let secondLine: [SpotType.CompanionType] = []
        
    }
    
    struct VisitPurpose {
        
        static let firstLine: [SpotType.VisitPurposeType] = [
            .meeting, .study
        ]
        
        static let secondLine: [SpotType.VisitPurposeType] = []
        
    }
    
}
