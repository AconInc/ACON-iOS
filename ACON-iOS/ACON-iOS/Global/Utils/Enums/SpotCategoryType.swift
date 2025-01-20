//
//  SpotCategoryType.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/21/25.
//

import Foundation

enum SpotCategoryType {
    
    case restaurant, cafe

    init?(engText: String) {
        switch engText {
        case "RESTAURANT": self = .restaurant
        case "CAFE": self = .cafe
        default: return nil
        }
    }
    
    init?(korText: String) {
        switch korText {
        case "음식점": self = .restaurant
        case "카페": self = .cafe
        default: return nil
        }
    }
    
}
