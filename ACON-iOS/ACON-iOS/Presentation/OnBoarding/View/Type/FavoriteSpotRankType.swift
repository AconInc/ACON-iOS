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
            return "분위기가 감각적인"
        case .new:
            return "새로운 음식의 경험"
        case .quality:
            return "합리적인 가격과 양"
        case .special:
            return "특별한 날, 고급스러운"
        }
    }

    var image: UIImage {
        switch self {
        case .mood:
            return .moodPlace
        case .new:
            return .newPlace
        case .quality:
            return .qualityPlace
        case .special:
            return .specialPlace
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
