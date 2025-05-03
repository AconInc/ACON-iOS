//
//  SpotListItemSizeType.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/15/25.
//

import Foundation

enum SpotListItemSizeType {
    
    case minimumLineSpacing, itemMaxWidth, itemMinWidth, itemMaxHeight, itemMinHeight, headerHeight, footerHeight
    
    var value: CGFloat {
        switch self {
        case .minimumLineSpacing: return -20
        case .itemMaxWidth: return 328 * ScreenUtils.widthRatio
        case .itemMinWidth: return 264 * ScreenUtils.widthRatio
        case .itemMaxHeight: return 444 * ScreenUtils.heightRatio
        case .itemMinHeight: return 380 * ScreenUtils.heightRatio
        case .headerHeight: return 54 + ScreenUtils.navViewHeight
        case .footerHeight: return 114
        }
    }
    
}
