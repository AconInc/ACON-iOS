//
//  UIButton+.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/6/25.
//

import UIKit

extension UIButton {
    
    // MARK: - 버튼 모서리 둥글게
    
    func roundedButton(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }


    // MARK: - Glassmorphism 배경 설정

    func setGlassmorphismBackground(
        _ cornerRadius: CGFloat,
        glassColor: UIColor = .clear,
        blurStyle: UIBlurEffect.Style = .systemUltraThinMaterial
    ) {
        let glassView = GlassmorphismView()
        glassView.clipsToBounds = true
        glassView.isUserInteractionEnabled = false
        glassView.layer.zPosition = -1 // NOTE: 버튼에 설정한 stroke를 가리지 않음
        glassView.layer.cornerRadius = cornerRadius
        glassView.setGlassColor(glassColor)
        glassView.setBlurStyle(blurStyle)
        
        self.insertSubview(glassView, at: 0)
        
        glassView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }


    // MARK: - 단일 ACStyle 타이틀 설정

    /// - Warning: Acon 버전 2.0.0 이후에서 더 이상 사용되지 않으며, 모두 대체되면 삭제될 예정입니다.
    @available(*, deprecated, message: "Acon 2.0부터 더 이상 사용되지 않습니다.")
    func setAttributedTitle(
        text: String,
        style: OldACFontStyleType,
        color: UIColor = .acWhite,
        for state: UIControl.State = .normal
    ) {
        let attributedString = text.ACStyle(style, color)
        self.setAttributedTitle(attributedString, for: state)
    }

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

    /// - Warning: Acon 버전 2.0.0 이후에서 더 이상 사용되지 않으며, 모두 대체되면 삭제될 예정입니다.
    @available(*, deprecated, message: "Acon 2.0부터 더 이상 사용되지 않습니다.")
    func setPartialTitle(
         fullText: String,
         textStyles: [(text: String, style: OldACFontStyleType, color: UIColor)]
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

         self.setAttributedTitle(attributedString, for: state)
     }

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
