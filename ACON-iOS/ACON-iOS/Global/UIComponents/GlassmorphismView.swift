//
//  GlassmorphismView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/20/25.
//

import UIKit

class GlassmorphismView: BaseView {
    
    // MARK: - Properties
    
    private lazy var blurEffectView = UIVisualEffectView(effect: nil)
    
    private lazy var vibrancyEffectView = UIVisualEffectView(effect: nil)
    
    private var glassMorphismType: GlassmorphismType
    
    
    // MARK: - LifeCycles
    
    init(_ glassMorphismType: GlassmorphismType) {
        self.glassMorphismType = glassMorphismType
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        vibrancyEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        self.backgroundColor = .clear
        
        setGlassMorphism(glassMorphismType)
    }
    
}


// MARK: - Set GlassMorphism

extension GlassmorphismView {
    
    func setGlassMorphism(_ type: GlassmorphismType) {
        blurEffectView.setBlurDensity(type.blurIntensity, type.blurEffectStyle)
        
        if let vibrancyStyle = type.vibrancyEffectStyle {
            vibrancyEffectView.effect = UIVibrancyEffect(
                blurEffect: UIBlurEffect(style: type.blurEffectStyle),
                style: vibrancyStyle
            )
            blurEffectView.contentView.addSubview(vibrancyEffectView)
        } else {
            vibrancyEffectView.removeFromSuperview()
        }
    }

}
