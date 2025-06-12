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
    
}

extension ACToastType {
    
    var title: String {
        switch self {
        case .profileSaved:
            return StringLiterals.Profile.doneSave
        case .locationChanged:
            return StringLiterals.SpotList.locationChangedToast
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
        }
    }
    
    var glassBorderAttributes: GlassBorderAttributes {
        switch self {
        case .locationChanged:
            return GlassBorderAttributes(width: 1, cornerRadius: 20, glassmorphismType: .buttonGlassDefault)
        case .profileSaved:
            return GlassBorderAttributes(width: 1, cornerRadius: 8, glassmorphismType: .buttonGlassDefault)
        }
    }
    
    var height: CGFloat {
        switch self {
        case .profileSaved:
            return 56
        case .locationChanged:
            return 48
        }
    }
    
}
