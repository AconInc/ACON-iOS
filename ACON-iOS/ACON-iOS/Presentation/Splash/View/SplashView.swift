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
    
    var logoLabel : UILabel = UILabel()
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(splashLottieView, logoLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
//        splashLottieView.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*145)
//            $0.centerX.equalToSuperview()
//            $0.width.equalToSuperview()
//        }
        
        logoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtils.heightRatio*344)
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
        
        logoLabel.do {
            $0.setLabel(text: StringLiterals.Login.logoText,
                        style: .s1,
                        color: .acWhite,
                        alignment: .center,
                        numberOfLines: 2)
        }
    }
    
}
