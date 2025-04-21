//
//  FilterTagButtonType.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

enum FilterTagButtonType {
    
    case selected, unselected
    
    var bgColor: UIColor {
        switch self {
        case .selected: return .primaryDefault.withAlphaComponent(0.35)
        case .unselected: return .gray8
        }
    }
    
    var strokeColor: UIColor {
        switch self {
        case .selected: return .primaryDefault
        case .unselected: return .gray6
        }
    }
    
    var textColor: UIColor {
        return .acWhite
    }
    
}

