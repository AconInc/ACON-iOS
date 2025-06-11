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
                     delayTime: Double = -1,
                     tapAction: (() -> Void)? = nil) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let toastView = ACToastView(acToastType, tapAction)
        
        window.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(Int(ScreenUtils.height)*bottomInset/780)
            $0.centerX.equalToSuperview()
        }
        
        if delayTime > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
                UIView.animate(withDuration: delayTime) {
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
