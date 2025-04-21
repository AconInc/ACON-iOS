//
//  FavoriteSpotRankType.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/16/25.
//

import UIKit

enum FavoriteSpotRankType: CaseIterable {
    
    case mood
    case new
    case quality
    case special

    var name: String {
        switch self {
        case .mood:
            return StringLiterals.FavoriteSpotRankTypes.mood
        case .new:
            return StringLiterals.FavoriteSpotRankTypes.new
        case .quality:
            return StringLiterals.FavoriteSpotRankTypes.quality
        case .special:
            return StringLiterals.FavoriteSpotRankTypes.special
        }
    }

    var image: UIImage {
        switch self {
        case .mood:
            return .imgMoodPlace
        case .new:
            return .imgNewPlace
        case .quality:
            return .imgQualityPlace
        case .special:
            return .imgSpecialPlace
        }
    }

    var mappedValue: String {
        switch self {
        case .mood:
            return "SENSE"
        case .new:
            return "NEW_FOOD"
        case .quality:
            return "REASONABLE"
        case .special:
            return "LUXURY"
        }
    }
    
}
