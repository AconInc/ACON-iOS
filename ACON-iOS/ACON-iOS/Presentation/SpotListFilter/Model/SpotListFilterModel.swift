//
//  SpotListFilterModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import Foundation

struct SpotListFilterModel {
    
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
        
        static let tags: [SpotType.CompanionType] = [
            .family, .date, .friend, .alone, .group
        ]
        
    }
    
    struct VisitPurpose {
        
        static let tags: [SpotType.VisitPurposeType] = [
            .meeting, .study
        ]
        
    }
    
}
