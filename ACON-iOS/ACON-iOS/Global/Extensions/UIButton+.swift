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
    
    
    // MARK: - 버튼 타이틀 설정
    
    func setAttributedTitle(
        text: String,
        style: ACFontStyleType,
        color: UIColor = .acWhite,
        for state: UIControl.State = .normal
    ) {
        let attributedString = text.ACStyle(style, color)
        self.setAttributedTitle(attributedString, for: state)
    }
    
}
