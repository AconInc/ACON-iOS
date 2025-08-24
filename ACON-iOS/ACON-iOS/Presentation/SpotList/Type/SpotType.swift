//
//  SpotType.swift
//  ACON-iOS
//
//  Created by 김유림 on 6/1/25.
//

import Foundation

enum SpotType {

    case restaurant, cafe

    var text: String {
        switch self {
        case .restaurant: return "음식점"
        case .cafe: return "카페"
        }
    }

    var serverKey: String {
        switch self {
        case .restaurant: return "RESTAURANT"
        case .cafe: return "CAFE"
        }
    }

    var firstLineCount: Int {
        switch self {
        case .restaurant: return 5
        case .cafe: return 1
        }
    }

    var secondLineCount: Int {
        switch self {
        case .restaurant: return 4
        case .cafe: return 0
        }
    }

}
