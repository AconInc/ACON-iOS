//
//  NoMatchingSpotItemSizeType.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/24/25.
//

import Foundation

enum NoMatchingSpotListItemSizeType {

    case minimumLineSpacing, itemWidth, itemHeight, withSuggestionHeaderHeight, noSuggestionHeaderHeight
    
    var value: CGFloat {
        switch self {
        case .minimumLineSpacing: return 12
        case .itemWidth: return 328 * ScreenUtils.widthRatio
        case .itemHeight: return 180
        case .withSuggestionHeaderHeight: return 216 + ScreenUtils.navViewHeight
        case .noSuggestionHeaderHeight: return 270 + ScreenUtils.navViewHeight
        }
    }

}
