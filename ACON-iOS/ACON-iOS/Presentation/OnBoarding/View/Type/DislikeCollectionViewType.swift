//
//  DislikeCollectionViewType.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/16/25.
//

import UIKit

enum DislikeType: CaseIterable {
    
    case dakbal
    case hoeYukhoe
    case gopchang
    case soondae
    case yanggogi
    case none

    var name: String {
        switch self {
        case .dakbal:
            return "닭발"
        case .hoeYukhoe:
            return "회/육회"
        case .gopchang:
            return "곱창/대창/막창"
        case .soondae:
            return "순대/선지"
        case .yanggogi:
            return "양고기"
        case .none:
            return " "
        }
    }

    var image: UIImage {
        switch self {
        case .dakbal:
            return .chickenFeet
        case .hoeYukhoe:
            return .sashimi
        case .gopchang:
            return .intestines
        case .soondae:
            return .soonde
        case .yanggogi:
            return .lamb
        case .none:
            return .none
        }
    }

    var mappedValue: String {
        switch self {
        case .dakbal:
            return "DAKBAL"
        case .hoeYukhoe:
            return "HOE_YUKHOE"
        case .gopchang:
            return "GOPCHANG"
        case .soondae:
            return "SUNDAE"
        case .yanggogi:
            return "YANGGOGI"
        case .none:
            return "NONE"
        }
    }
    
}
