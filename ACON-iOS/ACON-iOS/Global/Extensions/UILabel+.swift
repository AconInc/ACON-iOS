//
//  UILabel+.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/6/25.
//

import UIKit

extension UILabel {
    
    // MARK: - UILabel Text 설정
    
    func setText(_ style: ACFontStyleType, _ color: UIColor = .acWhite) {
        self.attributedText = text?.ACStyle(style, color)
    }
    
    
    // MARK: - UILabel 설정
    
    func setLabel(
        text: String,
        style: ACFontStyleType,
        color: UIColor = .acWhite,
        alignment: NSTextAlignment = .left,
        numberOfLines: Int = 0
    ) {
        self.text = text
        setText(style, color)
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
    }
    
    
    // MARK: - UILabel 내에서 스타일 다를 때
    
    func setPartialText(
        fullText: String,
        textStyles: [(text: String, style: ACFontStyleType, color: UIColor)]
    ) {
        let attributedString = NSMutableAttributedString(string: fullText)
        
        textStyles.forEach { textStyle in
            if let range = fullText.range(of: textStyle.text) {
                let nsRange = NSRange(range, in: fullText)
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: textStyle.style.font,
                    .kern: textStyle.style.kerning,
                    .paragraphStyle: {
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.minimumLineHeight = textStyle.style.lineHeight
                        paragraphStyle.maximumLineHeight = textStyle.style.lineHeight
                        return paragraphStyle
                    }(),
                    .foregroundColor: textStyle.color
                ]
                
                attributes.forEach { key, value in
                    attributedString.addAttribute(key, value: value, range: nsRange)
                }
            }
        }
        
        self.attributedText = attributedString
    }

    
    // MARK: - UILabel 밑줄
    
    func setUnderline(range: NSRange) {
        let attributedString: NSMutableAttributedString
        if let existingAttributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: existingAttributedText)
        } else { return }
        
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        self.attributedText = attributedString
    }

    
}
