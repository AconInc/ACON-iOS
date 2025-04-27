//
//  ACFontStyle.swift
//  ACON-iOS
//
//  Created by 김유림 on 4/27/25.
//

import UIKit

struct ACFontStyle {

    private let fontName: String
    let size: CGFloat
    let lineHeight: CGFloat

    var font: UIFont {
        return UIFont(name: fontName, size: size) ?? .systemFont(ofSize: size)
    }

    init(_ weight: ACFontType.Weight = .regular, size: CGFloat, lineHeight: CGFloat) {
        self.fontName = weight.fontName
        self.size = size
        self.lineHeight = lineHeight
    }

}


enum ACFontType {
    
    enum Weight {
        case light
        case regular
        case semibold

        var fontName: String {
            switch self {
            case .light: return "Pretendard-Light"
            case .regular: return "Pretendard-Regular"
            case .semibold: return "Pretendard-SemiBold"
            }
        }
    }

    case h1(_ weight: ACFontType.Weight)
    case h2(_ weight: ACFontType.Weight)
    case h3(_ weight: ACFontType.Weight)
    case h4(_ weight: ACFontType.Weight)

    case t1(_ weight: ACFontType.Weight)
    case t2(_ weight: ACFontType.Weight)
    case t3(_ weight: ACFontType.Weight)
    case t4(_ weight: ACFontType.Weight)
    case t5(_ weight: ACFontType.Weight)

    case b1(_ weight: ACFontType.Weight)

    case c1(_ weight: ACFontType.Weight)
    case c2(_ weight: ACFontType.Weight)

    var fontStyle: ACFontStyle {
        switch self {
        case .h1(let weight): return ACFontStyle(weight, size: 32, lineHeight: 42)
        case .h2(let weight): return ACFontStyle(weight, size: 28, lineHeight: 38)
        case .h3(let weight): return ACFontStyle(weight, size: 24, lineHeight: 34)
        case .h4(let weight): return ACFontStyle(weight, size: 20, lineHeight: 28)

        case .t1(let weight): return ACFontStyle(weight, size: 24, lineHeight: 34)
        case .t2(let weight): return ACFontStyle(weight, size: 20, lineHeight: 28)
        case .t3(let weight): return ACFontStyle(weight, size: 18, lineHeight: 26)
        case .t4(let weight): return ACFontStyle(weight, size: 16, lineHeight: 24)
        case .t5(let weight): return ACFontStyle(weight, size: 14, lineHeight: 20)

        case .b1(let weight): return ACFontStyle(weight, size: 14, lineHeight: 20)

        case .c1(let weight): return ACFontStyle(weight, size: 12, lineHeight: 18)
        case .c2(let weight): return ACFontStyle(weight, size: 11, lineHeight: 16)
        }
    }

    func kerning(isKorean: Bool) -> NSNumber {
        return NSNumber(value: isKorean ? fontStyle.size * 0.025 : 0)
    }

}
