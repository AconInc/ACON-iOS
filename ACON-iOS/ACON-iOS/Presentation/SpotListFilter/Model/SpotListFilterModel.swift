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
        
        var firstLine: [SpotType.CafeFeatureType] {
            return [.large, .goodView, .dessert, .terace]
        }
        
        var secondLine: [SpotType.CafeFeatureType] {
            return [.excludeFranchise]
        }
        
    }
    
    struct Companion {
        
        var firstLine: [SpotType.CompanionType] {
            return [.family, .date, .friend, .alone, .group]
        }
        
        var secondLine: [SpotType.CompanionType] {
            return []
        }
        
    }
    
    struct VisitPurpose {
        
        var firstLine: [SpotType.VisitPurposeType] {
            return [.meeting, .study]
        }
        
        var secondLine: [SpotType.VisitPurposeType] {
            return []
        }
        
    }
    
}
