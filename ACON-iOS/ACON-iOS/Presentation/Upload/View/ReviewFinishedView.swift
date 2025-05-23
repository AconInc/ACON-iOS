//
//  ReviewFinishedView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/13/25.
//

import UIKit

import Lottie

final class ReviewFinishedView: BaseView {

    // MARK: - UI Properties
    
    let finishedReviewLabel: UILabel = UILabel()
    
    private let wishYouPreferenceLabel: UILabel = UILabel()
    
    let finishedReviewLottieView: LottieAnimationView = LottieAnimationView()

    let doneButton: ACButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDisabled, buttonType: .full_12_t4SB), title: StringLiterals.Upload.done)
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(finishedReviewLabel,
                         wishYouPreferenceLabel,
                         finishedReviewLottieView,
                         doneButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        finishedReviewLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*127)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*88.5)
            $0.height.equalTo(56)
        }
        
        wishYouPreferenceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*195)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*72)
            $0.height.equalTo(20)
        }
        
        finishedReviewLottieView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(wishYouPreferenceLabel.snp.bottom).offset(56*ScreenUtils.heightRatio)
            $0.width.equalTo(ScreenUtils.width * 0.8)
        }
        
        doneButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(21+ScreenUtils.heightRatio*16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(54)
            $0.width.equalTo(ScreenUtils.widthRatio*328)
        }
        
    }
    
    override func setStyle() {
        super.setStyle()
        
        wishYouPreferenceLabel.do {
            $0.setLabel(text: StringLiterals.Upload.wishYouPreference,
                        style: .b1R,
                        color: .gray500,
                        alignment: .center)
        }
        
        finishedReviewLottieView.do {
            $0.animation = LottieAnimation.named("finishedUpload")
            $0.contentMode = .scaleAspectFit
        }
        
    }
    
}
