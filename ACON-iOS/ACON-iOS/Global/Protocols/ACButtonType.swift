//
//  ACButtonType.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/2/25.
//

import UIKit

// MARK: - Button Style

protocol ButtonStyleType {

    var backgroundColor: UIColor { get }
    
    var blurEffectStyle: UIBlurEffect.Style? { get }
    
    var blurIntensity: CGFloat? { get }
    
    var vibrancyEffect: UIVibrancyEffect? { get }
    
    var cornerRadius: CGFloat { get }
    
    var borderColor: UIColor { get }
    
    var borderWidth: CGFloat { get }
    
    var textColor: UIColor { get }
    
    var textStyle: ACFontType { get }
    
}

extension ButtonStyleType {
    
    var blurEffect: UIBlurEffect.Style? { return nil }
    
    var vibrancyEffect: UIVibrancyEffect? { return nil }
    
    var borderColor: UIColor { return .clear }
    
    var borderWidth: CGFloat { return 0 }
    
    var cornerRadius: CGFloat { return 0 }
    
}


// MARK: - Button Configuration

enum ButtonConfigStyle {
    
    case filled
    
    case plain
    
}

protocol ConfigButtonStyleType: ButtonStyleType {
    
    var configStyle: ButtonConfigStyle { get }
    
    var imagePlacement: NSDirectionalRectEdge { get }
    
    var imagePadding: CGFloat { get }
    
    var preferredSymbolConfigurationForImage: CGFloat { get }
    
    var titleAlignment: UIButton.Configuration.TitleAlignment { get }
    
    var contentInsets: NSDirectionalEdgeInsets { get }
    
    var showsActivityIndicator: Bool { get }
    
}


extension ConfigButtonStyleType {
    
    var configStyle: ButtonConfigStyle { return .plain }
    
    var imagePlacement: NSDirectionalRectEdge { return .leading }
    
    var imagePadding: CGFloat { return .zero }
    
    var titleAlignment: UIButton.Configuration.TitleAlignment { return .center }
    
    var showsActivityIndicator: Bool { return false }
    
}


// MARK: - Acon 2.0 Button Type

struct GlassDefault: ButtonStyleType {
    
    var backgroundColor: UIColor { return UIColor.acWhite.withAlphaComponent(0.2) }
    
    var blurEffectStyle: UIBlurEffect.Style? { return .systemUltraThinMaterialLight }

    var blurIntensity: CGFloat? { return 0.2 }
    
//    var vibrancyEffect: UIVibrancyEffect? { return UIVibrancyEffect(blurEffect: UIBlurEffect(style: .systemUltraThinMaterialLight), style: .secondaryFill) }
    
    var textColor: UIColor { return .acWhite }
    
    var textStyle: ACFontType
    
    var cornerRadius: CGFloat
    
    init(textStyle: ACFontType, cornerRadius: CGFloat) {
        self.textStyle = textStyle
        self.cornerRadius = cornerRadius
    }
    
}
