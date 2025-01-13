//
//  SpotListCollectionViewType.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/13/25.
//

import UIKit

enum MatchingRateBgColor {
    case dark, light
    
    var color: UIColor {
        switch self {
        case .dark: return .gray9
        case .light: return .glaB30
        }
    }
}


struct SpotListCollectionViewType {
    
    static let minimumLineHeight: CGFloat = 12
    
    static let itemWidth: CGFloat = ScreenUtils.width - 40
    
    static func longItemHeight(_ collectionViewHeight: CGFloat) -> CGFloat {
        let shortHeight = shortItemHeight(collectionViewHeight)
        return collectionViewHeight - shortHeight - 12
    }
    
    static func shortItemHeight(_ collectionViewHeight: CGFloat) -> CGFloat {
        return (collectionViewHeight - 12 * 3) / 4
    }
    
}
