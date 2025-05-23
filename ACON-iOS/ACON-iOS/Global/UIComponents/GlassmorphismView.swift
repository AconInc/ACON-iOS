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
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        // NOTE: 뷰 등장 시 기존 효과를 완전히 제거하고 다시 설정
        if window != nil {
            blurEffectView.effect = nil
            vibrancyEffectView.effect = nil
            
            DispatchQueue.main.async {
                self.setGlassMorphism(self.glassMorphismType)
            }
        }
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


// MARK: - Set Gradient

extension GlassmorphismView {
    
    func setGradient(topColor: UIColor = .gray900.withAlphaComponent(1),
                     bottomColor: UIColor = .gray900.withAlphaComponent(0.1)) {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer()
        }
        
        let gradient = CAGradientLayer()
        gradient.do {
            $0.frame = bounds
            $0.colors = [topColor.cgColor, bottomColor.cgColor]
            $0.startPoint = CGPoint(x: 0.5, y: 0.0)
            $0.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        layer.insertSublayer(gradient, at: 0)
    }
    
}
