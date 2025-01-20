//
//  ReviewFinishedView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/13/25.
//

import UIKit

import Lottie
import SnapKit
import Then

final class ReviewFinishedView: BaseView {

    // MARK: - UI Properties
    
    private let finishedReviewLabel: UILabel = UILabel()
    
    private let wishYouPreferenceLabel: UILabel = UILabel()
    
    let finishedReviewLottieView: LottieAnimationView = LottieAnimationView()
    
    private let closeViewLabel: UILabel = UILabel()
    
    var okButton: UIButton = UIButton()
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(finishedReviewLabel,
                         wishYouPreferenceLabel,
                         finishedReviewLottieView,
                         closeViewLabel,
                         okButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        finishedReviewLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*40/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(56)
        }
        
        wishYouPreferenceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*104/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(18)
        }
        
        finishedReviewLottieView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(ScreenUtils.height*162/780)
            // TODO: 디자인에게 사이즈 물어보기
            $0.width.equalTo(246)
            $0.height.equalTo(320)
        }
        
        closeViewLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*100/780)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(18)
        }
        
        okButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*36/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(52)
        }
        
    }
    
    override func setStyle() {
        super.setStyle()
        
        finishedReviewLabel.do {
            $0.setLabel(text: StringLiterals.Upload.finishedReview,
                        style: .h6,
                        color: .acWhite)
        }
        
        wishYouPreferenceLabel.do {
            $0.setLabel(text: StringLiterals.Upload.wishYouPreference,
                        style: .b3,
                        color: .gray3)
        }
        
        finishedReviewLottieView.do {
            $0.animation = LottieAnimation.named("finishedUpload")
            $0.contentMode = .scaleAspectFit
            // TODO: 디자인에게 반복재생 물어보기
        }
        
        closeViewLabel.do {
            $0.setLabel(text: StringLiterals.Upload.closeAfterFiveSeconds,
                        style: .b3,
                        color: .gray3)
        }
        
        okButton.do {
            $0.setAttributedTitle(text: StringLiterals.Upload.ok,
                                  style: .h8,
                                  color: .acWhite,
                                  for: .normal)
            $0.backgroundColor = .gray5
            $0.roundedButton(cornerRadius: 6, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
        }
    }
    
}
