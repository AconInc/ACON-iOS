//
//  String+.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/10/25.
//

import UIKit

extension String {

    /// - Warning: Acon 버전 2.0.0 이후에서 더 이상 사용되지 않으며, 모두 대체되면 삭제될 예정입니다.
    @available(*, deprecated, message: "Acon 2.0.0 이후에서 더 이상 사용되지 않습니다. \n 대신 `attributedString(_ style: ACFontType, _ color: UIColor = .acWhite)`를 사용하세요")
    func ACStyle(_ style: OldACFontStyleType, _ color: UIColor = .acWhite) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .kern: style.kerning,
            .paragraphStyle: {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.minimumLineHeight = style.lineHeight
                paragraphStyle.maximumLineHeight = style.lineHeight
                return paragraphStyle
            }(),
            .foregroundColor: color,
            .baselineOffset: (style.lineHeight - style.font.lineHeight) / 2
        ]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    /// kerning(한글: -2.5%, 그 외: 0%),  lineHeight, color가 적용된 스트링입니다.
    func attributedString(_ style: ACFontType, _ color: UIColor = .acWhite) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        // NOTE: 언어별로 kerning 다르게 적용(한글은 -2.5%, 그 외는 0%)
        var currentLocation = 0
        var index = self.startIndex
        
        while index < self.endIndex {
            let character = self[index]
            let language: Language = character.isKorean ? .korean : .other
            
            let languageEndIndex = self[index...].firstIndex {
                $0.isKorean != character.isKorean
            } ?? self.endIndex
            
            let partLength = self.distance(from: index, to: languageEndIndex)
            let partRange = NSRange(location: currentLocation, length: partLength)
            
            let kerning: NSNumber = style.kerning(isKorean: language == .korean)
            attributedString.addAttribute(
                .kern,
                value: kerning,
                range: partRange
            )
            
            // NOTE: 다음 단위로 이동
            currentLocation += partLength
            index = languageEndIndex
        }
        
        // NOTE: 스트링 전체에 속성 적용
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = style.fontStyle.lineHeight
        paragraphStyle.maximumLineHeight = style.fontStyle.lineHeight
        let baseLineOffset = NSNumber(value: (style.fontStyle.lineHeight - style.fontStyle.font.lineHeight) / 2)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: style.fontStyle.font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: baseLineOffset
        ]
        attributes.forEach { key, value in
            attributedString.addAttribute(
                key,
                value: value,
                range: NSRange(location: 0, length: self.count)
            )
            print("😡String+ Font lineHeight: \(style.fontStyle.lineHeight)")
            
        }
        
        return attributedString
    }
}


// MARK: - Language

extension String {

    enum Language {
        case korean
        case other
    }

    func detectLanguage() -> Language {
        // Unicode ranges for Korean characters
        let koreanRanges = [
            0xAC00...0xD7A3,  // Hangul Syllables
            0x1100...0x11FF,  // Hangul Jamo
            0x3130...0x318F   // Hangul Compatibility Jamo
        ]

        // If any character is in Korean ranges, return .korean
        let hasKoreanChars = self.unicodeScalars.contains { scalar in
            koreanRanges.contains { range in
                range.contains(Int(scalar.value))
            }
        }

        return hasKoreanChars ? .korean : .other
    }

}
