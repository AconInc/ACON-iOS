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
    
    var glassmorphismType: GlassmorphismType? { get }
    
    var borderGlassmorphismType: GlassmorphismType? { get }
    
    var glassButtonType: GlassButtonType? { get }
    
    var cornerRadius: CGFloat { get }
    
    var borderColor: UIColor { get }
    
    var borderWidth: CGFloat { get }
    
    var textColor: UIColor { get }
    
    var textStyle: ACFontType { get }
    
}

extension ButtonStyleType {
    
    var backgroundColor: UIColor { return .clear }
    
    var glassmorphismType: GlassmorphismType? { return nil }
    
    var borderGlassmorphismType: GlassmorphismType? { return nil }
    
    var glassButtonType: GlassButtonType? { return nil }
    
    var textColor: UIColor { return .acWhite }
    
    var textStyle: ACFontType { return .b1SB }
    
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

/// 글모가 적용된 버튼은 무조건 배경색상이 Clear이며, 배경색도 글모로 정합니다 !

struct GlassButton: ButtonStyleType {
    
    var glassmorphismType: GlassmorphismType?
    
    var borderGlassmorphismType: GlassmorphismType?
    
    var glassButtonType: GlassButtonType?
    
    var textStyle: ACFontType
    
    var textColor: UIColor
    
    var borderWidth: CGFloat
    
    var borderColor: UIColor
    
    var cornerRadius: CGFloat
    
    init(glassmorphismType: GlassmorphismType? = nil,
         borderGlassmorphismType: GlassmorphismType? = nil,
         buttonType: GlassButtonType) {
        self.glassmorphismType = glassmorphismType
        self.borderGlassmorphismType = borderGlassmorphismType
        self.glassButtonType = buttonType
        
        self.cornerRadius = buttonType.cornerRadius
        self.textStyle = buttonType.textStyle
        self.textColor = buttonType.textColor
        self.borderWidth = buttonType.borderWidth
        self.borderColor = buttonType.borderColor
    }
    
}


struct DefaultButton: ButtonStyleType { }

