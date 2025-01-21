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
            $0.horizontalEdges.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(ScreenUtils.height*214/780)
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
