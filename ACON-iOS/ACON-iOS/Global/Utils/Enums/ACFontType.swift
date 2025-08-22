//
//  ACFontStyle.swift
//  ACON-iOS
//
//  Created by 김유림 on 4/27/25.
//

import UIKit

struct ACFontStyle {

    private let fontName: String
    private let weight: ACFontType.Weight
    let size: CGFloat
    let lineHeight: CGFloat

    var font: UIFont {
        return UIFont(name: fontName, size: size) ?? .systemFont(ofSize: size, weight: weight.systemWeight)
    }

    init(_ weight: ACFontType.Weight = .regular, size: CGFloat, lineHeight: CGFloat) {
        self.fontName = weight.fontName
        self.weight = weight
        self.size = size
        self.lineHeight = lineHeight
    }

}


enum ACFontType {

    enum Weight {
        case light
        case regular
        case semibold
        case extraBold

        var fontName: String {
            switch self {
            case .light: return "Pretendard-Light"
            case .regular: return "Pretendard-Regular"
            case .semibold: return "Pretendard-SemiBold"
            case .extraBold: return "Pretendard-ExtraBold"
            }
        }

        var systemWeight: UIFont.Weight {
            switch self {
            case .light: return .light
            case .regular: return .regular
            case .semibold: return .semibold
            case .extraBold: return .heavy
            }
        }

    }

    case h1R, h1SB
    case h2R, h2SB
    case h3R, h3SB
    case h4R, h4SB

    case t1L, t1R, t1SB
    case t2L, t2R, t2SB
    case t3L, t3R, t3SB
    case t4L, t4R, t4SB
    case t5L, t5R, t5SB

    case b1L, b1R, b1SB

    case c1L, c1R, c1SB
    case c2L, c2R, c2SB

    var fontStyle: ACFontStyle {
        switch self {
        case .h1R: return ACFontStyle(.regular, size: 32, lineHeight: 42)
        case .h2R: return ACFontStyle(.regular, size: 28, lineHeight: 38)
        case .h3R: return ACFontStyle(.regular, size: 24, lineHeight: 34)
        case .h4R: return ACFontStyle(.regular, size: 20, lineHeight: 28)
        case .h1SB: return ACFontStyle(.semibold, size: 32, lineHeight: 42)
        case .h2SB: return ACFontStyle(.semibold, size: 28, lineHeight: 38)
        case .h3SB: return ACFontStyle(.semibold, size: 24, lineHeight: 34)
        case .h4SB: return ACFontStyle(.semibold, size: 20, lineHeight: 28)

        case .t1L: return ACFontStyle(.light, size: 24, lineHeight: 34)
        case .t2L: return ACFontStyle(.light, size: 20, lineHeight: 28)
        case .t3L: return ACFontStyle(.light, size: 18, lineHeight: 26)
        case .t4L: return ACFontStyle(.light, size: 16, lineHeight: 24)
        case .t5L: return ACFontStyle(.light, size: 14, lineHeight: 20)
        case .t1R: return ACFontStyle(.regular, size: 24, lineHeight: 34)
        case .t2R: return ACFontStyle(.regular, size: 20, lineHeight: 28)
        case .t3R: return ACFontStyle(.regular, size: 18, lineHeight: 26)
        case .t4R: return ACFontStyle(.regular, size: 16, lineHeight: 24)
        case .t5R: return ACFontStyle(.regular, size: 14, lineHeight: 20)
        case .t1SB: return ACFontStyle(.semibold, size: 24, lineHeight: 34)
        case .t2SB: return ACFontStyle(.semibold, size: 20, lineHeight: 28)
        case .t3SB: return ACFontStyle(.semibold, size: 18, lineHeight: 26)
        case .t4SB: return ACFontStyle(.semibold, size: 16, lineHeight: 24)
        case .t5SB: return ACFontStyle(.semibold, size: 14, lineHeight: 20)
            
        case .b1L: return ACFontStyle(.light, size: 14, lineHeight: 20)
        case .b1R: return ACFontStyle(.regular, size: 14, lineHeight: 20)
        case .b1SB: return ACFontStyle(.semibold, size: 14, lineHeight: 20)

        case .c1L: return ACFontStyle(.light, size: 12, lineHeight: 18)
        case .c2L: return ACFontStyle(.light, size: 11, lineHeight: 16)
        case .c1R: return ACFontStyle(.regular, size: 12, lineHeight: 18)
        case .c2R: return ACFontStyle(.regular, size: 11, lineHeight: 16)
        case .c1SB: return ACFontStyle(.semibold, size: 12, lineHeight: 18)
        case .c2SB: return ACFontStyle(.semibold, size: 11, lineHeight: 16)
        }
    }

    func kerning(isKorean: Bool) -> NSNumber {
        return NSNumber(value: isKorean ? fontStyle.size * 0.025 : 0)
    }

}
