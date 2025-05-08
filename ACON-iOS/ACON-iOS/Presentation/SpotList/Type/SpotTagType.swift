//
//  SpotTagType.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/3/25.
//

import Foundation

enum SpotTagType {
    
    case new
    case local
    case top(number: Int)
    
    var text: String {
        switch self {
        case .new: "NEW"
        case .local: "LOCAL"
        case .top(let number): "TOP \(String(number))"
        }
    }
    
}
