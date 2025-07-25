//
//  UIButton+.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/6/25.
//

import UIKit

import SnapKit

extension UIButton {

    // MARK: - 버튼 모서리 둥글게

    func roundedButton(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }


    // MARK: - 단일 ACStyle 타이틀 설정

    func setAttributedTitle(
         text: String,
         style: ACFontType,
         color: UIColor = .acWhite,
         for state: UIControl.State = .normal
     ) {
         let attributedString = text.attributedString(style, color)
         self.setAttributedTitle(attributedString, for: state)
     }


    // MARK: - 복수 ACStyle 타이틀 설정

     func setPartialTitle(
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

         self.setAttributedTitle(attributedString, for: state)
     }


    // MARK: - spotID Associated Object 추가
    
    private static var spotIDKey: UInt8 = 0
    
    var spotID: Int64 {
        get {
            return (objc_getAssociatedObject(self, &UIButton.spotIDKey) as? Int64) ?? 0
        }
        set {
            objc_setAssociatedObject(self, &UIButton.spotIDKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}


// MARK: - Alignment 타입 매핑

extension UIButton.Configuration.TitleAlignment {

    var toContentHorizontalAlignment: UIControl.ContentHorizontalAlignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        case .automatic: return .center
        @unknown default: return .center
        }
    }

}
