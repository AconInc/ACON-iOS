//
//  WithdrawalType.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/17/25.
//

import Foundation

import UIKit

enum WithdrawalType: CaseIterable {
    
    case optionLackOfRestaurants
    
    case optionUnsatisfiedRecommendation
    
    case optionFakeReviews
    
    case optionOthers
    
    var name: String {
        switch self {
            
        case .optionLackOfRestaurants: return StringLiterals.Withdrawal.optionLackOfRestaurants
            
        case .optionUnsatisfiedRecommendation: return StringLiterals.Withdrawal.optionUnsatisfiedRecommendation
            
        case .optionFakeReviews: return StringLiterals.Withdrawal.optionFakeReviews
            
        case .optionOthers: return StringLiterals.Withdrawal.optionOthers
            
        }
    }
    
    var mappedValue: String {
        switch self {
            
        case .optionLackOfRestaurants: return StringLiterals.Withdrawal.optionLackOfRestaurants
            
        case .optionUnsatisfiedRecommendation: return StringLiterals.Withdrawal.optionUnsatisfiedRecommendation
            
        case .optionFakeReviews: return StringLiterals.Withdrawal.optionFakeReviews
            
        case .optionOthers: return StringLiterals.Withdrawal.optionOthers
            
        }
    }
    
}
