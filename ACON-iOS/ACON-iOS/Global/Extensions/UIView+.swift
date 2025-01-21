//
//  UIView+.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/6/25.
//

import UIKit

extension UIView {
    
    // MARK: - UIView 여러 개 한 번에 addSubview
    
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    
    // MARK: - 뷰 모서리 둥글게
    
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
    
    
    // MARK: - blurView subView로 추가
    
    func setBlurView(){
        let viewBlurEffect = UIVisualEffectView()
        viewBlurEffect.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        
        self.addSubview(viewBlurEffect)
        viewBlurEffect.frame = self.bounds
    }
    
}
