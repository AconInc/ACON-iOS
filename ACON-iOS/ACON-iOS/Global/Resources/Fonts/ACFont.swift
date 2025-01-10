//
//  ACFont.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/8/25.
//

import UIKit

enum ACFont {
    
    private enum FontName {
        
        static let bold = "Pretendard-Bold"
        static let semibold = "Pretendard-SemiBold"
        static let medium = "Pretendard-Medium"
        static let regular = "Pretendard-Regular"
        
    }
    
    private static func font(name: String, size: CGFloat, weight: UIFont.Weight) -> UIFont {
        return UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: weight)
    }
    
    
    // MARK: - Heading
    
    static let h1 = ACFontStyleType(
        font: font(name: FontName.semibold, size: 32, weight: .semibold),
        kerning: 32 * -0.023,
        lineHeight: 42
    )
    
    static let h2 = ACFontStyleType(
        font: font(name: FontName.semibold, size: 28, weight: .semibold),
        kerning: 28 * -0.023,
        lineHeight: 38
    )
    
    static let h3 = ACFontStyleType(
        font: font(name: FontName.semibold, size: 26, weight: .semibold),
        kerning: 26 * -0.023,
        lineHeight: 36
    )
    
    static let h4 = ACFontStyleType(
        font: font(name: FontName.semibold, size: 24, weight: .semibold),
        kerning: 24 * -0.023,
        lineHeight: 34
    )
    
    static let h5 = ACFontStyleType(
        font: font(name: FontName.semibold, size: 22, weight: .semibold),
        kerning: 22 * -0.023,
        lineHeight: 30
    )
    
    static let h6 = ACFontStyleType(
        font: font(name: FontName.semibold, size: 20, weight: .semibold),
        kerning: 20 * -0.023,
        lineHeight: 28
    )
    
    static let h7 = ACFontStyleType(
        font: font(name: FontName.semibold, size: 18, weight: .semibold),
        kerning: 18 * -0.023,
        lineHeight: 26
    )
    
    static let h8 = ACFontStyleType(
        font: font(name: FontName.semibold, size: 16, weight: .semibold),
        kerning: 16 * -0.023,
        lineHeight: 24
    )
    
    
    // MARK: - Title
    
    static let t1 = ACFontStyleType(
        font: font(name: FontName.bold, size: 24, weight: .bold),
        kerning: 24 * -0.023,
        lineHeight: 34
    )
    
    static let t2 = ACFontStyleType(
        font: font(name: FontName.bold, size: 20, weight: .bold),
        kerning: 20 * -0.023,
        lineHeight: 28
    )
    
    static let t3 = ACFontStyleType(
        font: font(name: FontName.bold, size: 18, weight: .bold),
        kerning: 18 * -0.023,
        lineHeight: 26
    )
    
    
    // MARK: - Subtitle
    
    static let s1 = ACFontStyleType(
        font: font(name: FontName.medium, size: 16, weight: .medium),
        kerning: 16 * -0.023,
        lineHeight: 24
    )
    
    static let s2 = ACFontStyleType(
        font: font(name: FontName.medium, size: 14, weight: .medium),
        kerning: 14 * -0.023,
        lineHeight: 20
    )
    
    
    // MARK: - Body
    
    static let b1 = ACFontStyleType(
        font: font(name: FontName.regular, size: 15, weight: .regular),
        kerning: 15 * -0.023,
        lineHeight: 22
    )
    
    static let b2 = ACFontStyleType(
        font: font(name: FontName.regular, size: 14, weight: .regular),
        kerning: 14 * -0.023,
        lineHeight: 20
    )
    
    static let b3 = ACFontStyleType(
        font: font(name: FontName.regular, size: 13, weight: .regular),
        kerning: 13 * -0.023,
        lineHeight: 18
    )
    
    static let b4 = ACFontStyleType(
        font: font(name: FontName.regular, size: 12, weight: .regular),
        kerning: 12 * -0.023,
        lineHeight: 18
    )
    
    
    // MARK: - Caption
    
    static let c1 = ACFontStyleType(
        font: font(name: FontName.regular, size: 11, weight: .regular),
        kerning: 11 * -0.023,
        lineHeight: 16
    )
    
}
