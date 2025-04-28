//
//  ACFontStyle.swift
//  ACON-iOS
//
//  Created by 김유림 on 4/27/25.
//

import UIKit

// MARK: - FontStyleType

/// - Warning: Acon 버전 2.0.0 이후에서 더 이상 사용되지 않으며, 모두 대체되면 삭제될 예정입니다.
@available(*, deprecated, message: "Acon 2.0부터 더 이상 사용되지 않습니다. 대신 `ACFontStyleType`을 사용하세요")
struct OldACFontStyleType {
    
    let font: UIFont
    let kerning: CGFloat
    let lineHeight: CGFloat
    
}

extension OldACFontStyleType {
    
    static var h1: OldACFontStyleType { OldACFont.h1 }
    static var h2: OldACFontStyleType { OldACFont.h2 }
    static var h3: OldACFontStyleType { OldACFont.h3 }
    static var h4: OldACFontStyleType { OldACFont.h4 }
    static var h5: OldACFontStyleType { OldACFont.h5 }
    static var h6: OldACFontStyleType { OldACFont.h6 }
    static var h7: OldACFontStyleType { OldACFont.h7 }
    static var h8: OldACFontStyleType { OldACFont.h8 }
    
    static var t1: OldACFontStyleType { OldACFont.t1 }
    static var t2: OldACFontStyleType { OldACFont.t2 }
    static var t3: OldACFontStyleType { OldACFont.t3 }
    
    static var s1: OldACFontStyleType { OldACFont.s1 }
    static var s2: OldACFontStyleType { OldACFont.s2 }
    
    static var b1: OldACFontStyleType { OldACFont.b1 }
    static var b2: OldACFontStyleType { OldACFont.b2 }
    static var b3: OldACFontStyleType { OldACFont.b3 }
    static var b4: OldACFontStyleType { OldACFont.b4 }
    
    static var c1: OldACFontStyleType { OldACFont.c1 }
    
}


// MARK: - Font

/// - Warning: Acon 버전 2.0.0 이후에서 더 이상 사용되지 않으며, 모두 대체되면 삭제될 예정입니다.
@available(*, deprecated, message: "Acon 2.0부터 더 이상 사용되지 않습니다. 대신 `ACFont`를 사용하세요")
enum OldACFont {
    
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
    
    static let h1 = OldACFontStyleType(
        font: font(name: FontName.semibold, size: 32, weight: .semibold),
        kerning: 32 * -0.023,
        lineHeight: 42
    )
    
    static let h2 = OldACFontStyleType(
        font: font(name: FontName.semibold, size: 28, weight: .semibold),
        kerning: 28 * -0.023,
        lineHeight: 38
    )
    
    static let h3 = OldACFontStyleType(
        font: font(name: FontName.semibold, size: 26, weight: .semibold),
        kerning: 26 * -0.023,
        lineHeight: 36
    )
    
    static let h4 = OldACFontStyleType(
        font: font(name: FontName.semibold, size: 24, weight: .semibold),
        kerning: 24 * -0.023,
        lineHeight: 34
    )
    
    static let h5 = OldACFontStyleType(
        font: font(name: FontName.semibold, size: 22, weight: .semibold),
        kerning: 22 * -0.023,
        lineHeight: 30
    )
    
    static let h6 = OldACFontStyleType(
        font: font(name: FontName.semibold, size: 20, weight: .semibold),
        kerning: 20 * -0.023,
        lineHeight: 28
    )
    
    static let h7 = OldACFontStyleType(
        font: font(name: FontName.semibold, size: 18, weight: .semibold),
        kerning: 18 * -0.023,
        lineHeight: 26
    )
    
    static let h8 = OldACFontStyleType(
        font: font(name: FontName.semibold, size: 16, weight: .semibold),
        kerning: 16 * -0.023,
        lineHeight: 24
    )
    
    
    // MARK: - Title
    
    static let t1 = OldACFontStyleType(
        font: font(name: FontName.bold, size: 24, weight: .bold),
        kerning: 24 * -0.023,
        lineHeight: 34
    )
    
    static let t2 = OldACFontStyleType(
        font: font(name: FontName.bold, size: 20, weight: .bold),
        kerning: 20 * -0.023,
        lineHeight: 28
    )
    
    static let t3 = OldACFontStyleType(
        font: font(name: FontName.bold, size: 18, weight: .bold),
        kerning: 18 * -0.023,
        lineHeight: 26
    )
    
    
    // MARK: - Subtitle
    
    static let s1 = OldACFontStyleType(
        font: font(name: FontName.medium, size: 16, weight: .medium),
        kerning: 16 * -0.023,
        lineHeight: 24
    )
    
    static let s2 = OldACFontStyleType(
        font: font(name: FontName.medium, size: 14, weight: .medium),
        kerning: 14 * -0.023,
        lineHeight: 20
    )
    
    
    // MARK: - Body
    
    static let b1 = OldACFontStyleType(
        font: font(name: FontName.regular, size: 15, weight: .regular),
        kerning: 15 * -0.023,
        lineHeight: 22
    )
    
    static let b2 = OldACFontStyleType(
        font: font(name: FontName.regular, size: 14, weight: .regular),
        kerning: 14 * -0.023,
        lineHeight: 20
    )
    
    static let b3 = OldACFontStyleType(
        font: font(name: FontName.regular, size: 13, weight: .regular),
        kerning: 13 * -0.023,
        lineHeight: 18
    )
    
    static let b4 = OldACFontStyleType(
        font: font(name: FontName.regular, size: 12, weight: .regular),
        kerning: 12 * -0.023,
        lineHeight: 18
    )
    
    
    // MARK: - Caption
    
    static let c1 = OldACFontStyleType(
        font: font(name: FontName.regular, size: 11, weight: .regular),
        kerning: 11 * -0.023,
        lineHeight: 16
    )
    
}
