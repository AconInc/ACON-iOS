//
//  GlassmorphismView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/20/25.
//

import UIKit

class GlassmorphismView: BaseView {
    
    // MARK: - Properties
    
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    
    private let vibrancyEffectView = UIVisualEffectView(
        effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .regular))
    )
    
    
    // MARK: - LifeCycles
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(vibrancyEffectView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        blurEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    override func setStyle() {
        self.backgroundColor = .clear
        vibrancyEffectView.backgroundColor = .glaB30
    }
    
}


// MARK: - UI Update Methods

extension GlassmorphismView {
    
    // NOTE: - GlassmorphismView에는 기본적으로 glass color = .glaB30이 적용되어 있습니다.
    func setGlassColor(_ color: UIColor) {
        vibrancyEffectView.backgroundColor = color
    }
    
    func setBlurStyle(_ style: UIBlurEffect.Style) {
        blurEffectView.effect = UIBlurEffect(style: style)
    }
    
}
