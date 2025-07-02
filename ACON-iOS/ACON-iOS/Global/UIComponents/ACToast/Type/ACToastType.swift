//
//  ACToastType.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/23/25.
//

import UIKit

enum ACToastType {
    
    case profileSaved
    
    case locationChanged
    
    case canChangeLocalVerification
    
}

extension ACToastType {
    
    var title: String {
        switch self {
        case .profileSaved:
            return StringLiterals.Profile.doneSave
        case .locationChanged:
            return StringLiterals.SpotList.locationChangedToast
        case .canChangeLocalVerification:
            return StringLiterals.LocalVerification.canChangeLocalVerification
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .locationChanged:
            return .labelAction
        default:
            return .acWhite
        }
    }
    
    var titleFont: ACFontType {
        switch self {
        case .profileSaved, .locationChanged:
            return .t4R
        case .canChangeLocalVerification:
            return .b1R
        }
    }
    
    var glassBorderAttributes: GlassBorderAttributes {
        switch self {
        case .locationChanged:
            return GlassBorderAttributes(width: 1, cornerRadius: 20, glassmorphismType: .buttonGlassDefault)
        case .profileSaved:
            return GlassBorderAttributes(width: 1, cornerRadius: 8, glassmorphismType: .buttonGlassDefault)
        case .canChangeLocalVerification:
            return GlassBorderAttributes(width: 1, cornerRadius: 20, glassmorphismType: .buttonGlassPressed)
        }
    }
    
    var height: CGFloat {
        switch self {
        case .profileSaved:
            return 56
        case .locationChanged:
            return 48
        case .canChangeLocalVerification:
            return 40
        }
    }
    
}
