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
            return StringLiterals.DislikeTypes.dakbal
        case .hoeYukhoe:
            return StringLiterals.DislikeTypes.hoeYukhoe
        case .gopchang:
            return StringLiterals.DislikeTypes.gopchang
        case .soondae:
            return StringLiterals.DislikeTypes.soondae
        case .yanggogi:
            return StringLiterals.DislikeTypes.yanggogi
        case .none:
            return StringLiterals.DislikeTypes.none
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
