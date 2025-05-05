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

struct GlassDefault: ButtonStyleType {
    
    var glassmorphismType: GlassmorphismType? { return .buttonGlassDefault }
    
    var borderGlassmorphismType: GlassmorphismType?
    
    var borderWidth: CGFloat
    
    var cornerRadius: CGFloat
    
    init(cornerRadius: CGFloat, textStyle: ACFontType = .b1SB, borderWidth: CGFloat = 0) {
        self.cornerRadius = cornerRadius
        self.textStyle = textStyle
        self.borderWidth = borderWidth
    }
    
}

struct GlassSelected: ButtonStyleType {
    
    var glassmorphismType: GlassmorphismType? { return .buttonGlassSelected }
    
    var textStyle: ACFontType
    
    var borderWidth: CGFloat
    
    var cornerRadius: CGFloat
    
    init(cornerRadius: CGFloat, textStyle: ACFontType, borderWidth: CGFloat = 0) {
        self.textStyle = textStyle
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
    }
    
}

struct GlassDisabled: ButtonStyleType {
    
    var glassmorphismType: GlassmorphismType? { return .buttonGlassDisabled }
    
    var textStyle: ACFontType
    
    var borderWidth: CGFloat
    
    var cornerRadius: CGFloat
    
    init(textStyle: ACFontType, cornerRadius: CGFloat, borderWidth: CGFloat = 0) {
        self.textStyle = textStyle
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
    }
    
}

struct GlassPressed: ButtonStyleType {
    
    var glassmorphismType: GlassmorphismType? { return .buttonGlassPressed }
    
    var textStyle: ACFontType
    
    var borderWidth: CGFloat
    
    var cornerRadius: CGFloat
    
    init(textStyle: ACFontType, cornerRadius: CGFloat, borderWidth: CGFloat = 0) {
        self.textStyle = textStyle
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
    }
    
}
