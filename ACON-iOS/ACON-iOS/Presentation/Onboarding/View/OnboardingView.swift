//
//  OnboardingView.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/8/25.
//

import UIKit

final class OnboardingView: BaseView {

    // MARK: - UI Properties
    
    private let titleLabel: UILabel = UILabel()
    
    private let descriptionLabel: UILabel = UILabel()
    
    var noDislikeFoodButton : ACButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_19_b1R), title: "없음")
    
    lazy var dislikeFoodCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: dislikeFoodCollectionViewFlowLayout)
    
    let commentLabel: UILabel = UILabel()
    
    let lightImageView: UIImageView = UIImageView()
    
    var startButton: ACButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_12_t4SB), title: StringLiterals.Onboarding.start)
    
    private let dislikeFoodCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.do {
            $0.scrollDirection = .vertical
            $0.minimumInteritemSpacing = 8
            $0.minimumLineSpacing = 8
            $0.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            $0.estimatedItemSize = CGSize(width: 100, height: 38)
        }
        return layout
    }()
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(titleLabel,
                         descriptionLabel,
                         noDislikeFoodButton,
                         dislikeFoodCollectionView,
                         lightImageView,
                         commentLabel,
                         startButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*140)
            $0.leading.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.height.equalTo(68)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*218)
            $0.leading.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.height.equalTo(21)
        }
        
        noDislikeFoodButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*279)
            $0.leading.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.height.equalTo(38)
            $0.width.equalTo(48)
        }
        
        dislikeFoodCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*333)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(176)
        }
        
        lightImageView.snp.makeConstraints {
            $0.size.equalTo(275)
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*531)
            $0.centerX.equalToSuperview()
        }
        
        commentLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(21+ScreenUtils.heightRatio*80)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }

        startButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(21+ScreenUtils.heightRatio*16)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.height.equalTo(54)
        }
        
    }
    
    override func setStyle() {
        super.setStyle()
        
        titleLabel.do {
            $0.setLabel(text: StringLiterals.Onboarding.dislikeFoodTitle, style: .t1SB)
        }
        
        descriptionLabel.do {
            $0.setLabel(text: StringLiterals.Onboarding.dislikeFoodDescription,
                        style: .t5R,
                        color: .gray500)
        }

        noDislikeFoodButton.do {
            $0.updateGlassButtonState(state: .default)
        }
        
        dislikeFoodCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
        }
        
        commentLabel.do {
            $0.isHidden = true
        }
        
        lightImageView.do {
            $0.image = .imgOnboardingBackground
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
            $0.isHidden = true
        }
        
        startButton.do {
            $0.updateGlassButtonState(state: .disabled)
        }
        
    }
    
}


