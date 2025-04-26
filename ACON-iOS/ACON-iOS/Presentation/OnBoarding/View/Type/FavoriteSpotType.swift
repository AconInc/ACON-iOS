//
//  FavoriteSpotType.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/16/25.
//

import UIKit

enum FavoriteSpotType: CaseIterable {
    
    case restaurant
    case cafe
    
    var name: String {
        switch self {
        case .restaurant: return StringLiterals.FavoriteSpotTypes.restaurant
        case .cafe: return StringLiterals.FavoriteSpotTypes.cafe
        }
    }
    
    var image: UIImage {
        switch self {
        case .restaurant: return .imgRestaurant
        case .cafe: return .imgCafe
        }
    }
    
    var mappedValue: String {
        switch self {
        case .restaurant: return "RESTAURANT"
        case .cafe: return "CAFE"
        }
    }
    
}
