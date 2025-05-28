//
//  ACToastType.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/23/25.
//

import UIKit

enum ACToastType {
    
    case profileSaved
    
}

extension ACToastType {
    
    var title: String {
        switch self {
        case .profileSaved:
            return StringLiterals.Profile.doneSave
        }
    }
    
    var titleColor: UIColor {
        switch self {
        default:
            return .acWhite
        }
    }
    
    var titleFont: ACFontType {
        switch self {
        case .profileSaved:
            return .t4R
        }
    }
    
    var glassBorderAttributes: GlassBorderAttributes {
        switch self {
        case .profileSaved:
            return GlassBorderAttributes(width: 1, cornerRadius: 8, glassmorphismType: .buttonGlassDefault)
        }
    }
    
}
