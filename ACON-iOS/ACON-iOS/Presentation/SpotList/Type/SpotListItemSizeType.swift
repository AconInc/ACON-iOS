//
//  SpotListItemSizeType.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/15/25.
//

import Foundation

enum SpotListItemSizeType {
    
    case minimumLineSpacing, itemWidth, headerHeight
    
    var value: CGFloat {
        switch self {
        case .minimumLineSpacing: return 12
        case .itemWidth: return ScreenUtils.width - 40
        case .headerHeight: return 38
        }
    }
    
}
