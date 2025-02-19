//
//  FilterConductButton.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/20/25.
//

import UIKit

import Lottie

class LoadingAnimatedButton: UIButton {
    
    // MARK: - UI Properties
    
    private let animationView = LottieAnimationView(name: "loadingWhite")
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setStyle()
        addTarget()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}


// MARK: - UI Settings

private extension LoadingAnimatedButton {
    
    func setHierarchy() {
        self.addSubview(animationView)
    }
    
    func setLayout() {
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(28)
        }
    }
    
    func setStyle() {
        animationView.do {
            $0.isHidden = true
        }
    }
    
    func addTarget() {
        self.addTarget(self, action: #selector(toggleSelf), for: .touchUpInside)
    }
    
}


// MARK: - @objc functions

private extension LoadingAnimatedButton {
    
    @objc
    func toggleSelf(_ sender: UIButton) {
        isSelected.toggle()
    }
    
}


// MARK: - Internal Methods

extension LoadingAnimatedButton {
    
    func startLoadingAnimation() {
        titleLabel?.isHidden = true
        imageView?.isHidden = true
        animationView.isHidden = false
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func endLoadingAnimation() {
        titleLabel?.isHidden = false
        imageView?.isHidden = false
        animationView.isHidden = true
        animationView.loopMode = .playOnce
        
        animationView.play(completion: { (isFinished) in
            if isFinished {
                self.animationView.stop()
            }
        })
    }
    
}
