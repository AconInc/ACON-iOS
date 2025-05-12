//
//  GlassmorphismType.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/4/25.
//

import UIKit

enum GlassmorphismType {
    
    case buttonGlassDefault, buttonGlassPressed, buttonGlassSelected, buttonGlassDisabled
    case bottomSheetGlass, actionSheetGlass, alertGlass, toastGlass, gradientGlass
    case noImageErrorGlass, needLoginErrorGlass
    case backgroundGlass
    
    var blurIntensity: CGFloat {
        switch self {
        case .buttonGlassDefault, .buttonGlassPressed, .buttonGlassSelected, .buttonGlassDisabled, .toastGlass, .gradientGlass, .noImageErrorGlass:
            return 0.2
        case .bottomSheetGlass, .alertGlass, .actionSheetGlass, .needLoginErrorGlass:
            return 0.4
        case .backgroundGlass:
            return 1
        }
    }
    
    var blurEffectStyle: UIBlurEffect.Style {
        switch self {
        case .buttonGlassDefault, .actionSheetGlass, .alertGlass, .noImageErrorGlass:
            return .systemThinMaterialLight
        case .buttonGlassPressed:
            return .systemThickMaterialLight
        case .buttonGlassSelected:
            return .systemMaterialLight
        case .buttonGlassDisabled, .bottomSheetGlass:
            return .systemUltraThinMaterialLight
        case .toastGlass, .needLoginErrorGlass:
            return .systemThinMaterialDark
        case .gradientGlass:
            return .systemUltraThinMaterialDark
        case .backgroundGlass:
            return .systemThinMaterialDark
        }
    }
    
    var vibrancyEffectStyle: UIVibrancyEffectStyle? {
        return nil
    }
    
}
