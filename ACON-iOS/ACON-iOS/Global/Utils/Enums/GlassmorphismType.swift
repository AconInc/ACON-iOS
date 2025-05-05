//
//  GlassmorphismType.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/4/25.
//

import UIKit

enum GlassmorphismType {
    
    case buttonGlassDefault, buttonGlassPressed, buttonGlassSelected, buttonGlassDisabled
    case bottomSheetGlass, actionSheetGlass, alertGlass
    
    var blurIntensity: CGFloat {
        switch self {
        case .buttonGlassDefault, .buttonGlassPressed, .buttonGlassSelected, .buttonGlassDisabled:
            return 0.2
        case .bottomSheetGlass, .alertGlass, .actionSheetGlass:
            return 0.4
        }
    }
    
    var blurEffectStyle: UIBlurEffect.Style {
        switch self {
        case .buttonGlassDefault, .buttonGlassPressed, .buttonGlassSelected, .buttonGlassDisabled:
            return .systemThickMaterialLight
        case .bottomSheetGlass, .alertGlass, .actionSheetGlass:
            return .light
        }
    }
    
    var vibrancyEffectStyle: UIVibrancyEffectStyle? {
        switch self {
        case .buttonGlassDefault, .buttonGlassPressed, .buttonGlassSelected, .buttonGlassDisabled:
            return nil
        case .bottomSheetGlass, .alertGlass, .actionSheetGlass:
            return nil
        }
    }
    
}
