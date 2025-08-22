//
//  SplashView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import UIKit

import Lottie
import AVFAudio

class SplashView: BaseView {
    
    let splashLottieView = LottieAnimationView(name: StringLiterals.Lottie.splashLottie)
    
    let shadowImageView: UIImageView = UIImageView()
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(splashLottieView, shadowImageView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        splashLottieView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*416)
            $0.width.equalTo(ScreenUtils.widthRatio*240)
            $0.height.equalTo(ScreenUtils.heightRatio*120)
            $0.centerX.equalToSuperview()
        }
        
        shadowImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*340)
            $0.centerX.equalToSuperview()
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
        
        shadowImageView.do {
            $0.image = .imgSplashShadow
            $0.alpha = 0.05
            $0.contentMode = .scaleAspectFit
        }
    }
    
}
