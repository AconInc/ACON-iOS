//
//  UILabel+.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/6/25.
//

import UIKit

extension UILabel {
    

    // MARK: - UILabel Text 설정

    func setText(
        _ style: ACFontType,
        _ color: UIColor = .acWhite,
        _ lineBreakMode: NSLineBreakMode? = nil
    ) {
        self.attributedText = text?.attributedString(style, color, lineBreakMode)
    }

    
    // MARK: - UILabel 설정

    func setLabel(
        text: String,
        style: ACFontType,
        color: UIColor = .acWhite,
        alignment: NSTextAlignment = .left,
        numberOfLines: Int = 0,
        lineBreakMode: NSLineBreakMode? = nil
    ) {
        self.text = text
        setText(style, color, lineBreakMode)
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
    }


    // MARK: - UILabel 내에서 스타일 다를 때

    func setPartialText(
         fullText: String,
         textStyles: [(text: String, style: ACFontType, color: UIColor)]
    ) {
        let attributedString = NSMutableAttributedString(string: fullText)

        textStyles.forEach { textStyle in
            guard let range = fullText.range(of: textStyle.text) else { return }
            let nsRange = NSRange(range, in: fullText)
            let subText = textStyle.text
            var currentLocation = nsRange.location
            var index = subText.startIndex
            
            // NOTE: 언어별로 kerning 다르게 적용(한글은 -2.5%, 그 외는 0%)
            while index < subText.endIndex {
                let character = subText[index]
                let isKorean = character.isKorean
                let languageEndIndex = subText[index...].firstIndex {
                    $0.isKorean != character.isKorean
                } ?? subText.endIndex
                
                let partLength = subText.distance(from: index, to: languageEndIndex)
                let partRange = NSRange(location: currentLocation, length: partLength)
                
                let kerning = textStyle.style.kerning(isKorean: isKorean)
                attributedString.addAttribute(
                   .kern,
                   value: kerning,
                   range: partRange
                )
                currentLocation += partLength
                index = languageEndIndex
            }
            
            // NOTE: 부분 스트링 전체에 속성 적용
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = textStyle.style.fontStyle.lineHeight
            paragraphStyle.maximumLineHeight = textStyle.style.fontStyle.lineHeight
            let baseLineOffset = NSNumber(value: Double((textStyle.style.fontStyle.lineHeight - textStyle.style.fontStyle.font.lineHeight) / 2))
            
            let commonAttributes: [NSAttributedString.Key: Any] = [
               .font: textStyle.style.fontStyle.font,
               .foregroundColor: textStyle.color,
               .paragraphStyle: paragraphStyle,
               .baselineOffset: baseLineOffset
            ]

            attributedString.addAttributes(commonAttributes, range: nsRange)
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
