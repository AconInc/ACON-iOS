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
    static let h1 = font(name: FontName.semibold, size: 32, weight: .semibold)
    static let h2 = font(name: FontName.semibold, size: 28, weight: .semibold)
    static let h3 = font(name: FontName.semibold, size: 26, weight: .semibold)
    static let h4 = font(name: FontName.semibold, size: 24, weight: .semibold)
    static let h5 = font(name: FontName.semibold, size: 22, weight: .semibold)
    static let h6 = font(name: FontName.semibold, size: 20, weight: .semibold)
    static let h7 = font(name: FontName.semibold, size: 18, weight: .semibold)
    static let h8 = font(name: FontName.semibold, size: 16, weight: .semibold)
    
    // MARK: - Title
    static let t1 = font(name: FontName.bold, size: 24, weight: .bold)
    static let t2 = font(name: FontName.bold, size: 20, weight: .bold)
    static let t3 = font(name: FontName.bold, size: 18, weight: .bold)
    
    // MARK: - Subtitle
    static let s1 = font(name: FontName.medium, size: 16, weight: .semibold)
    static let s2 = font(name: FontName.medium, size: 14, weight: .regular)
    
    // MARK: - Body
    static let b1 = font(name: FontName.regular, size: 15, weight: .regular)
    static let b2 = font(name: FontName.regular, size: 14, weight: .regular)
    static let b3 = font(name: FontName.regular, size: 13, weight: .regular)
    static let b4 = font(name: FontName.regular, size: 12, weight: .regular)

    // MARK: - caption
    static let c1 = font(name: FontName.regular, size: 11, weight: .regular)
}
