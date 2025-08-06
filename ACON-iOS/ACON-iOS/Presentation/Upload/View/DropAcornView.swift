//
//  DropAcornView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/13/25.
//

import UIKit

import Lottie

final class DropAcornView: BaseView {

    // MARK: - UI Properties
    
    var spotNameLabel: UILabel = UILabel()
    
    private let dropAcornLabel: UILabel = UILabel()
    
    var acornStackView: UIStackView = UIStackView()
    
    private let goAheadDropAcornLabel: UILabel = UILabel()
    
    var acornReviewLabel: UILabel = UILabel()
    
    let lightImageView: UIImageView = UIImageView()
    
    var dropAcornLottieView: LottieAnimationView = LottieAnimationView()
    
    var leaveReviewButton: ACButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_12_t4SB), title: StringLiterals.Upload.reviewWithAcornsHere)
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(spotNameLabel,
                         dropAcornLabel,
                         acornStackView,
                         goAheadDropAcornLabel,
                         acornReviewLabel,
                         lightImageView,
                         dropAcornLottieView,
                         leaveReviewButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        spotNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*37)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*20)
            $0.height.equalTo(26)
        }
        
        dropAcornLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*71)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        acornStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*115)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(256*ScreenUtils.heightRatio)
            $0.height.equalTo(48*ScreenUtils.heightRatio)
        }
        
        goAheadDropAcornLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*179)
        }
        
        acornReviewLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*203)
            $0.height.equalTo(20)
        }
        
        lightImageView.snp.makeConstraints {
            $0.size.equalTo(275)
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*439)
            $0.centerX.equalToSuperview()
        }
        
        dropAcornLottieView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*249)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.heightRatio*266)
        }

        leaveReviewButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(21+ScreenUtils.heightRatio*16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(54)
            $0.width.equalTo(ScreenUtils.widthRatio*328)
        }
        
    }
    
    override func setStyle() {
        super.setStyle()
        
        dropAcornLabel.do {
            $0.setLabel(text: StringLiterals.Upload.shallWeDropAcorns, style: .t5SB)
        }
        
        acornStackView.do {
            for _ in 0...4 {
                let acornImageView = makeAcornImageButton()
                $0.addArrangedSubview(acornImageView)
            }
            $0.distribution = .fillEqually
        }
        
        goAheadDropAcornLabel.do {
            $0.setLabel(text: StringLiterals.Upload.clickAcorn,
                        style: .b1R,
                        color: .gray500)
        }
        
        acornReviewLabel.do {
            $0.setLabel(text: "0/5",
                        style: .b1SB,
                        color: .gray500)
        }

        lightImageView.do {
            $0.image = .imgOnboardingBackground
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
            $0.isHidden = true
        }

        leaveReviewButton.do {
            $0.updateGlassButtonState(state: .disabled)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        leaveReviewButton.refreshButtonBlurEffect(.buttonGlassDefault)
    }
    
}

extension DropAcornView {
    
    func makeAcornImageButton() -> UIButton {
        let button = UIButton()
        button.snp.makeConstraints {
            $0.size.equalTo(48*ScreenUtils.heightRatio)
        }
        button.do {
            $0.setImage(.icAcornBlackFill, for: .normal)
            $0.setImage(.icAcornWhiteFill, for: .selected)
            $0.contentMode = .scaleAspectFit
        }
        return button
    }
    
}
