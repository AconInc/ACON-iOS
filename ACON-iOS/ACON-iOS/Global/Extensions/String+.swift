//
//  String+.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/10/25.
//

import UIKit

extension String {
    
    func ACStyle(_ style: ACFontStyleType, _ color: UIColor = .acWhite) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .kern: style.kerning,
            .paragraphStyle: {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.minimumLineHeight = style.lineHeight
                paragraphStyle.maximumLineHeight = style.lineHeight
                return paragraphStyle
            }(),
            .foregroundColor: color
        ]
        return NSAttributedString(string: self, attributes: attributes)
    }
    
}
