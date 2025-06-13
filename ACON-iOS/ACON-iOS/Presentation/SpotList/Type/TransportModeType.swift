//
//  TransportModeType.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/29/25.
//

import Foundation

enum TransportModeType {

    case walking, biking

    var serverKey: String {
        switch self {
        case .walking: return "WALKING"
        case .biking: return "BIKING"
        }
    }

    var naverMapKey: String {
        switch self {
        case .walking: return "walk"
        case .biking: return "bicycle"
        }
    }
}


// MARK: - init

extension TransportModeType {

    init?(_ serverKey: String?) {
        switch serverKey {
        case "WALKING": self = .walking
        case "BIKING": self = .biking
        default: return nil
        }
    }

}
