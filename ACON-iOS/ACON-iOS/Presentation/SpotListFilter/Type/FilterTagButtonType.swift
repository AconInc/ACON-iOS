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
        case .selected: return .subOrg35
        case .unselected: return .gray8
        }
    }
    
    var strokeColor: UIColor {
        switch self {
        case .selected: return .org1
        case .unselected: return .gray6
        }
    }
    
    var textColor: UIColor {
        return .acWhite
    }
    
}

