//
//  ACToastController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/17/25.
//

import UIKit

import SnapKit
import Then

final class ACToastController {
    
    static func show(_ acToastType: ACToastType,
                     bottomInset: Int = 92,
                     duration: Double = -1,
                     tapAction: (() -> Void)? = nil) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let toastView = ACToastView(acToastType, tapAction)
        
        window.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*Double(bottomInset))
            $0.centerX.equalToSuperview()
        }
        
        if duration > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                UIView.animate(withDuration: duration) {
                    toastView.alpha = 0
                } completion: { _ in
                    toastView.removeFromSuperview()
                }
            }
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first else { return }
            
            window.subviews.filter { $0 is ACToastView }.forEach { $0.removeFromSuperview() }
        }
    }
    
}
