//
//  GlassButtonType.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/5/25.
//

import UIKit

enum GlassButtonType {
    case full_12_t4SB
    case line_12_b1SB
    case full_10_b1SB
    case full_100_b1SB
    case full_100_b1r
    case both_20_labelAction_t4R
    
    var cornerRadius: CGFloat {
        switch self {
        case .full_100_b1SB, .full_100_b1r:
            return 100
        case .both_20_labelAction_t4R:
            return 20
        case .full_12_t4SB, .line_12_b1SB:
            return 12
        case .full_10_b1SB:
            return 10
        }
    }
    
    var textStyle: ACFontType {
        switch self {
        case .full_100_b1SB, .line_12_b1SB, .full_10_b1SB:
            return .b1SB
        case .both_20_labelAction_t4R:
            return .t4R
        case .full_12_t4SB:
            return .t4SB
        case .full_100_b1r:
            return .b1R
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .line_12_b1SB, .both_20_labelAction_t4R:
            return 1
        default:
            return 0
        }
    }
    
    var borderColor: UIColor {
        switch self {
        default:
            return .clear
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .both_20_labelAction_t4R:
            return .labelAction
        default:
            return .acWhite
        }
    }
    
}
