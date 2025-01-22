//
//  SpotListCollectionViewType.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/13/25.
//

import UIKit

enum MatchingRateBgColorType {
    
    case dark, light
    
    var color: UIColor {
        switch self {
        case .dark: return .gray9
        case .light: return .glaW20
        }
    }
    
}
