//
//  FavoriteCuisineType.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/16/25.
//

import UIKit

enum FavoriteCuisineType: CaseIterable {
    
    case korean
    case western
    case chinese
    case japanese
    case koreanStreet
    case asian
    
    var name: String {
        switch self {
        case .korean: return "한식"
        case .western: return "양식"
        case .chinese: return "중식"
        case .japanese: return "일식"
        case .koreanStreet: return "분식"
        case .asian: return "아시안"
        }
    }
    
    var image: UIImage {
        switch self {
        case .korean: return .koreaFood
        case .western: return .westFood
        case .chinese: return .chineseFood
        case .japanese: return .japaneseFood
        case .koreanStreet: return .koreaStreetFood
        case .asian: return .asianFood
        }
    }
    
    var mappedValue: String {
        switch self {
        case .korean: return "KOREAN"
        case .western: return "WESTERN"
        case .chinese: return "CHINESE"
        case .japanese: return "JAPANESE"
        case .koreanStreet: return "KOREAN_STREET"
        case .asian: return "ASIAN"
        }
    }
    
}
