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
            return "분위기와 인테리어가\n 감각적인 곳"
        case .new:
            return "새로운 음식을\n 경험할 수 있는 곳"
        case .quality:
            return "가격과 양이\n 합리적인 곳"
        case .special:
            return "특별한 날을 위한\n 고급스러운 장소"
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
