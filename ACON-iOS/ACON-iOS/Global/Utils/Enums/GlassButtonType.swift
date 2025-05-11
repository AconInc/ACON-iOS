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
    
    case full_22_b1SB
    
    case full_19_b1R
    
    case both_20_labelAction_t4R
    
    var cornerRadius: CGFloat {
        switch self {
        case .full_22_b1SB:
            return 22
        case .full_19_b1R:
            return 19
        case .both_20_labelAction_t4R:
            return 20
        case .full_12_t4SB, .line_12_b1SB:
            return 12
        case .full_10_b1SB:
            return 10
        }
    }
    
    var contentInsets: NSDirectionalEdgeInsets {
        switch self {
        case .full_12_t4SB:
            return .init(top: 15, leading: 15, bottom: 15, trailing: 15)
        case .line_12_b1SB: // TODO: 무슨 컴포넌트인지 못찾겠어서 임의 수치 넣음. 추후 수정
            return .init(top: 15, leading: 15, bottom: 15, trailing: 15)
        case .full_22_b1SB:
            return .init(top: 12, leading: 12, bottom: 12, trailing: 12)
        case .full_19_b1R:
            return .init(top: 9, leading: 12, bottom: 9, trailing: 12)
        case .full_10_b1SB:
            return .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        case .both_20_labelAction_t4R:
            return .init(top: 12, leading: 12, bottom: 12, trailing: 12)
        }
    }
    
    var textStyle: ACFontType {
        switch self {
        case .full_22_b1SB, .line_12_b1SB, .full_10_b1SB:
            return .b1SB
        case .both_20_labelAction_t4R:
            return .t4R
        case .full_12_t4SB:
            return .t4SB
        case .full_19_b1R:
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
