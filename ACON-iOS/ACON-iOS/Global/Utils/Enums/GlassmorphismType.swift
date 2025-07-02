//
//  GlassmorphismType.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/4/25.
//

import UIKit

enum GlassmorphismType {
    
    case buttonGlassDefault, buttonGlassPressed, buttonGlassSelected, buttonGlassDisabled
    case bottomSheetGlass, actionSheetGlass, alertGlass, textfieldGlass, gradientGlass, toastGlass
    case noImageErrorGlass, needLoginErrorGlass
    case backgroundGlass
    
    var blurIntensity: CGFloat {
        switch self {
        case .buttonGlassDefault, .buttonGlassPressed, .buttonGlassSelected, .buttonGlassDisabled, .textfieldGlass, .gradientGlass, .noImageErrorGlass, .toastGlass:
            return 0.2
        case .alertGlass, .actionSheetGlass, .needLoginErrorGlass:
            return 0.4
        case .bottomSheetGlass:
            return 0.6
        case .backgroundGlass:
            return 1
        }
    }
    
    var blurEffectStyle: UIBlurEffect.Style {
        switch self {
        case .buttonGlassDisabled:
            return .systemUltraThinMaterialLight
        case .buttonGlassDefault, .actionSheetGlass, .noImageErrorGlass:
            return .systemThinMaterialLight
        case .buttonGlassSelected:
            return .systemMaterialLight
        case .buttonGlassPressed:
            return .systemThickMaterialLight
        case .gradientGlass:
            return .systemUltraThinMaterialDark
        case .textfieldGlass, .needLoginErrorGlass, .alertGlass, .backgroundGlass, .bottomSheetGlass:
            return .systemThinMaterialDark
        case .toastGlass:
            return .systemThickMaterialDark
        }
    }
    
    var vibrancyEffectStyle: UIVibrancyEffectStyle? {
        return nil
    }
    
}
