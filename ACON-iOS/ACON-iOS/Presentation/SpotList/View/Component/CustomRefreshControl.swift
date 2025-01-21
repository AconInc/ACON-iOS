//
//  CustomRefreshControl.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/21/25.
//

import UIKit

import Lottie
import SnapKit

class CustomRefreshControl: UIRefreshControl {
    
    // MARK: - Properties
    
    private let animationView = LottieAnimationView(name: "loadingWhite")
    
    
    // MARK: - Life Cycles
    
    override init() {
        super.init(frame: .zero)
        
        setHierarchy()
        setLayout()
        setStyle()
        addTarget()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        animationView.loopMode = .loop
        animationView.play()
    }
    
    override func endRefreshing() {
        animationView.loopMode = .playOnce
        animationView.play(completion: { (isFinished) in
            if isFinished {
                super.endRefreshing()
                self.animationView.stop()
            }
        })
    }
    
    private func addTarget() {
        addTarget(self, action: #selector(beginRefreshing), for: .valueChanged)
    }
    
}


// MARK: - UI Settings

private extension CustomRefreshControl {
    
    func setHierarchy() {
        addSubview(animationView)
    }
    
    func setLayout() {
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(36)
        }
    }
    
    func setStyle() {
        tintColor = .clear
    }
    
}
