//
//  SpotListItemSizeType.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/15/25.
//

import Foundation

enum SpotListItemSizeType {
    
    case minimumLineSpacing, itemWidth, longItemHeight, shortItemHeight, headerHeight, footerHeight
    
    var value: CGFloat {
        switch self {
        case .minimumLineSpacing: return 12
        case .itemWidth: return ScreenUtils.width - 40
        case .longItemHeight: return SpotListItemSizeType.itemWidth.value * 1.24
        case .shortItemHeight: return SpotListItemSizeType.itemWidth.value * 0.39
        case .headerHeight: return 38 + ScreenUtils.navViewHeight
        case .footerHeight: return 114
        }
    }
    
}
