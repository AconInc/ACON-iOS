//
//  LoginModalView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/22/25.
//

import UIKit

class LoginModalView: GlassmorphismView {
    
    // MARK: - UI Properties
    
    let exitButton = UIButton()
    
    private let titleLabel = UILabel()
    
    private var subTitleLabel  = UILabel()
    
    var googleLoginButton = UIButton()
    
    var appleLoginButton = UIButton()
    
    private let youAgreedLabel = UILabel()
    
    private let termsStackView = UIStackView()
    
    var termsOfUseLabel = UILabel()
    
    var privacyPolicyLabel = UILabel()
    
    var socialLoginButtonConfiguration: UIButton.Configuration = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .leading
        configuration.imagePadding = 60
        configuration.titleAlignment = .center
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 24)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 24, bottom: 15, trailing: 24)
        return configuration
    }()
    
    private let loginButtonHeight: CGFloat = 54
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(
            exitButton,
            titleLabel,
            subTitleLabel,
            googleLoginButton,
            appleLoginButton,
            youAgreedLabel,
            termsStackView
        )
        
        termsStackView.addArrangedSubviews(
            termsOfUseLabel,
            privacyPolicyLabel
        )
    }
    
    override func setLayout() {
        super.setLayout()
        
        exitButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtils.heightRatio * 21)
            $0.trailing.equalToSuperview().offset(-ScreenUtils.widthRatio * 16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtils.heightRatio * 86)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        googleLoginButton.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(ScreenUtils.heightRatio * 64)
            $0.height.equalTo(ScreenUtils.heightRatio * 48)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*20)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(googleLoginButton.snp.bottom).offset(8)
            $0.height.horizontalEdges.equalTo(googleLoginButton)
        }
        
        youAgreedLabel.snp.makeConstraints {
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(ScreenUtils.heightRatio * 16)
            $0.centerX.equalToSuperview()
        }
        
        termsStackView.snp.makeConstraints {
            $0.top.equalTo(youAgreedLabel.snp.bottom).offset(ScreenUtils.heightRatio * 4)
            $0.centerX.equalToSuperview()
        }
        
        termsOfUseLabel.snp.makeConstraints {
            $0.width.equalTo(48)
        }
        
        privacyPolicyLabel.snp.makeConstraints {
            $0.width.equalTo(95)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setHandlerImageView()
        
        exitButton.setImage(.icDismiss, for: .normal)
        
        titleLabel.setLabel(text: StringLiterals.LoginModal.title,
                            style: .h4(.semibold),
                            color: .acWhite,
                            alignment: .center,
                            numberOfLines: 1)
        
        subTitleLabel.setLabel(text: StringLiterals.LoginModal.subTitle,
                               style: .b1(.regular),
                               color: .gray200,
                               alignment: .center,
                        numberOfLines: 2)
        
        googleLoginButton.do {
            $0.configuration = socialLoginButtonConfiguration
            $0.contentHorizontalAlignment = .leading
            $0.layer.cornerRadius = loginButtonHeight / 2
            $0.backgroundColor = .acWhite
            $0.setImage(.icGoogle, for: .normal)
            $0.setAttributedTitle(text: StringLiterals.Login.googleLogin,
                                  style: .t4(.semibold),
                                  color: .gray500)
        }
        
        appleLoginButton.do {
            $0.configuration = socialLoginButtonConfiguration
            $0.contentHorizontalAlignment = .leading
            $0.layer.cornerRadius = loginButtonHeight / 2
            $0.backgroundColor = .gray900
            $0.setImage(.icApple, for: .normal)
            $0.setAttributedTitle(text: StringLiterals.Login.appleLogin,
                                  style: .t4(.semibold),
                                  color: .acWhite)
            $0.layer.borderColor = UIColor.gray500.cgColor
            $0.layer.borderWidth = 1
        }
        
        youAgreedLabel.do {
            $0.setLabel(text: StringLiterals.Login.youAgreed,
                        style: .b1(.regular),
                        color: .gray300,
                        alignment: .center,
                        numberOfLines: 2)
        }
        
        termsStackView.do {
            $0.axis = .horizontal
            $0.spacing = 16
        }
        
        termsOfUseLabel.do {
            $0.setLabel(text: StringLiterals.Login.termsOfUse,
                        style: .c1(.regular),
                        color: .gray500)
            $0.setUnderline(
                range: NSRange(location: 0,
                               length: termsOfUseLabel.text?.count ?? 4))
            $0.isUserInteractionEnabled = true
        }
        
        privacyPolicyLabel.do {
            $0.setLabel(text: StringLiterals.Login.privacyPolicy,
                        style: .c1(.regular),
                        color: .gray500)
            $0.setUnderline(
                range: NSRange(location: 0,
                               length: privacyPolicyLabel.text?.count ?? 8))
            $0.isUserInteractionEnabled = true
        }
    }
    
}
