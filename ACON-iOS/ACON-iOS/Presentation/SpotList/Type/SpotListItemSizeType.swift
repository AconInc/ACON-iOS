//
//  SpotListItemSizeType.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/15/25.
//

import Foundation

enum SpotListItemSizeType {
    
    case minimumLineSpacing, itemWidth, longItemHeight, shortItemHeight, headerHeight
    
    var value: CGFloat {
        switch self {
        case .minimumLineSpacing: return 12
        case .itemWidth: return ScreenUtils.width - 40
        case .longItemHeight: return 408
        case .shortItemHeight: return 128
        case .headerHeight: return 38
        }
    }
    
}
