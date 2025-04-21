//
//  DropAcornView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/13/25.
//

import UIKit

import Lottie
import SnapKit
import Then

final class DropAcornView: BaseView {

    // MARK: - UI Properties
    
    private let dropAcornLabel: UILabel = UILabel()
    
    private let useAcornToReviewLabel: UILabel = UILabel()
    
    var acornNumberLabel: UILabel = UILabel()
    
    var acornStackView: UIStackView = UIStackView()
    
    var acornReviewLabel: UILabel = UILabel()
    
    private let goAheadDropAcornLabel: UILabel = UILabel()
    
    var dropAcornLottieView: LottieAnimationView = LottieAnimationView()
    
    var leaveReviewButton: UIButton = UIButton()
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(dropAcornLabel,
                         useAcornToReviewLabel,
                         acornNumberLabel,
                         acornStackView,
                         acornReviewLabel,
                         goAheadDropAcornLabel,
                         dropAcornLottieView,
                         leaveReviewButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        dropAcornLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*32)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*20)
            $0.height.equalTo(56)
        }
        
        useAcornToReviewLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*96)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*20)
            $0.height.equalTo(18)
        }
        
        acornNumberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*122)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*20)
            $0.height.equalTo(18)
        }
        
        acornStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*214)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(240)
            $0.height.equalTo(48)
        }
        
        acornReviewLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*192)
            $0.height.equalTo(18)
        }
        
        goAheadDropAcornLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*274)
        }
        
        dropAcornLottieView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(104)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.heightRatio*266)
        }
        
        leaveReviewButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*40)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*16)
            $0.height.equalTo(ScreenUtils.heightRatio*52)
        }
        
    }
    
    override func setStyle() {
        super.setStyle()
        
        dropAcornLabel.do {
            $0.setLabel(text: StringLiterals.Upload.shallWeDropAcorns,
                        style: .h6,
                        color: .acWhite)
        }
        
        useAcornToReviewLabel.do {
            $0.setLabel(text: StringLiterals.Upload.useAcornToReview,
                        style: .b3,
                        color: .gray3)
        }
        
        acornStackView.do {
            for _ in 0...4 {
                let acornImageView = makeAcornImageButton()
                $0.addArrangedSubview(acornImageView)
            }
        }
        
        acornReviewLabel.do {
            $0.setLabel(text: "0/5",
                        style: .b4,
                        color: .gray5)
        }
        
        goAheadDropAcornLabel.do {
            $0.setLabel(text: StringLiterals.Upload.clickAcorn,
                        style: .b2,
                        color: .acWhite)
        }
        
        leaveReviewButton.do {
            $0.setAttributedTitle(text: StringLiterals.Upload.reviewWithAcornsHere,
                                   style: .h8,
                                  color: .gray5,
                                  for: .disabled)
            $0.setAttributedTitle(text: StringLiterals.Upload.next,
                                   style: .h8,
                                  color: .acWhite,
                                  for: .normal)
            $0.backgroundColor = .gray5
            $0.roundedButton(cornerRadius: 6, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
        }
    }
    
}

extension DropAcornView {
    
    func makeAcornImageButton() -> UIButton {
        let button = UIButton()
        button.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
        button.do {
            $0.setImage(.icGReview, for: .normal)
            $0.setImage(.icWReview, for: .selected)
            $0.contentMode = .scaleAspectFit
        }
        return button
    }
    
}

extension DropAcornView {
    
    func bindData(_ acornCount: Int) {
        self.acornNumberLabel.do {
            $0.setPartialText(fullText: StringLiterals.Upload.acornsIHave + " \(acornCount)/25", textStyles: [(StringLiterals.Upload.acornsIHave, .b4, .gray5), (" \(acornCount)/25", .b4, .primaryDefault)])
        }
    }
    
}
