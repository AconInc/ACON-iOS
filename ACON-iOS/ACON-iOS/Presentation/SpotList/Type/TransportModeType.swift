//
//  TransportModeType.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/29/25.
//

import Foundation
import MapKit

enum TransportModeType {

    case walking, biking, publicTransit

    var naverMapKey: String {
        switch self {
        case .walking: return "walk"
        case .biking: return "bicycle"
        case .publicTransit: return "public"
        }
    }

    var appleMapLaunchOption: String {
        switch self {
        case .walking, .biking: return MKLaunchOptionsDirectionsModeWalking
        case .publicTransit: return MKLaunchOptionsDirectionsModeDriving
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
