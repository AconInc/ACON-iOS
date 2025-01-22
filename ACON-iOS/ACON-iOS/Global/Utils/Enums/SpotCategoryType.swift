//
//  SpotCategoryType.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/21/25.
//

import Foundation

enum SpotCategoryType: String, Codable {
    
    case RESTAURANT = "RESTAURANT"
    
    case CAFE = "CAFE"
    
    
    var koreanText: String {
        switch self {
        case .RESTAURANT:
            return "음식점"
        case .CAFE:
            return "카페"
        }
    }
    
}
