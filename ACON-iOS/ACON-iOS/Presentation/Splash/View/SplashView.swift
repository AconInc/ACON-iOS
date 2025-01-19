//
//  SplashView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import UIKit

import Lottie
import SnapKit
import Then

class SplashView: BaseView {
    
    let splashLottieView = LottieAnimationView(name: "splashLottie")
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(splashLottieView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        splashLottieView.snp.makeConstraints {
            // TODO: - 디자인한테 물어보고 수정
            $0.centerY.equalToSuperview()
            $0.height.equalTo(390)
            $0.width.equalTo(180)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        splashLottieView.do {
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .playOnce
            $0.animationSpeed = 1.0
            $0.backgroundBehavior = .pauseAndRestore
        }
    }
    
}
