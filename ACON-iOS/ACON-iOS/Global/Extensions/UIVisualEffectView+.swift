//
//  UIVisualEffectView+.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/2/25.
//

import UIKit

extension UIVisualEffectView {
    
    private static var animatorKey: UInt8 = 0
    
    private var blurAnimator: UIViewPropertyAnimator? {
        get { return objc_getAssociatedObject(self, &UIVisualEffectView.animatorKey) as? UIViewPropertyAnimator }
        set { objc_setAssociatedObject(self, &UIVisualEffectView.animatorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func setBlurDensity(_ density: CGFloat, _ style: UIBlurEffect.Style = .light) {
        let clampedDensity = max(0, min(density, 1))
        
        if blurAnimator == nil {
            blurAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
        }
        
        blurAnimator?.stopAnimation(true)
        blurAnimator?.addAnimations { [weak self] in
            self?.effect = UIBlurEffect(style: style)
        }
        blurAnimator?.fractionComplete = clampedDensity
    }
    
}
