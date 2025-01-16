//
//  BaseView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/7/25.
//

import UIKit

import SnapKit
import Then

class BaseView: UIView {

    private let handlerImageView: UIImageView = UIImageView()
    
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setHierarchy()
        setLayout()
        setStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setHierarchy() {}

    func setLayout() {}
    
    func setStyle() {
        self.backgroundColor = .gray9
    }

}

// MARK: setHandlerImage for Modal

extension BaseView {

    func setHandlerImageView() {
        self.addSubview(handlerImageView)

        handlerImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*4/780)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.height*36/780)
            $0.height.equalTo(ScreenUtils.height*3/780)
        }

        handlerImageView.do {
            $0.image = .btnBottomsheetBar
            $0.contentMode = .scaleAspectFit
        }
    }

}

extension BaseView {
    
    // TODO: - 수정예정
    func addGlassCard(style: UIBlurEffect.Style = .systemUltraThinMaterialDark) {
        let glassCard = UIView()
        
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = glassCard.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.frame = glassCard.bounds
        vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        glassCard.addSubview(blurView)
        blurView.contentView.addSubview(vibrancyView)
        
        glassCard.layer.cornerRadius = 20
        glassCard.layer.masksToBounds = true
        glassCard.layer.borderWidth = 0.5
        glassCard.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        self.addSubview(glassCard)
    }
    
}
