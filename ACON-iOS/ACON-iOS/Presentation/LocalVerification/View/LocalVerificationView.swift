//
//  LocalVerificationView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import UIKit

import SnapKit
import Then

final class LocalVerificationView: BaseView {

    // MARK: - UI Properties
    
    private let backgroundImageView: UIImageView = UIImageView()
    
    private let titleLabel: UILabel = UILabel()
    
    private let descriptionLabel: UILabel = UILabel()
    
    private let oneSecondLabel: UILabel = UILabel()
    
    var nextButton: ACButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_12_t4SB), title: StringLiterals.LocalVerification.next)
    

    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(backgroundImageView,
                         titleLabel,
                         descriptionLabel,
                         oneSecondLabel,
                         nextButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        backgroundImageView.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.heightRatio*480)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*256)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*455)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(68)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*535)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        oneSecondLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*613)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(21+ScreenUtils.heightRatio*16)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.height.equalTo(54)
        }
        
    }
    
    override func setStyle() {
        super.setStyle()
        
        backgroundImageView.do {
            $0.image = .imgBackgroundLocalCertification
        }
        
        titleLabel.do {
            $0.setLabel(text: StringLiterals.LocalVerification.title,
                        style: .t1SB,
                        alignment: .center)
        }
        
        descriptionLabel.do {
            $0.setLabel(text: StringLiterals.LocalVerification.description,
                        style: .b1R,
                        color: .gray50)
        }
        
        oneSecondLabel.do {
            $0.setLabel(text: StringLiterals.LocalVerification.oneSecond,
                        style: .b1R,
                        color: .gray500)
        }
    }
    
}

