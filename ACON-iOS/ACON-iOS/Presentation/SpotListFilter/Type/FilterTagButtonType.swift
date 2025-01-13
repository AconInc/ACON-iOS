//
//  FilterTagButtonType.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

enum FilterTagButtonType {
    
    case unselected, selected
    
    var bgColor: UIColor {
        switch self {
        case .unselected: return .gray8
        case .selected: return .subOrg35
        }
    }
    
}

