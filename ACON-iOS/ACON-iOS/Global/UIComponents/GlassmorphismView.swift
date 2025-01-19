//
//  GlassmorphismView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/20/25.
//

import UIKit

class GlassmorphismView: BaseView {
    
    // MARK: - Properties
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    
    // MARK: - LifeCycles
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubview(blurView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    override func setStyle() {
        self.backgroundColor = .clear
        blurView.backgroundColor = .glaB30
    }
    
}


// MARK: - UI Update Methods

extension GlassmorphismView {
    
    /// GlassmorphismView에는 기본적으로 glass color = .glaB30이 적용되어 있습니다.
    func setGlassColor(_ color: UIColor = .glaB30) {
        blurView.backgroundColor = color
    }
    
}
