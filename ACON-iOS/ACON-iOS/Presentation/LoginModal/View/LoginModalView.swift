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
        configuration.imagePadding = 4
        configuration.titleAlignment = .center
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 28)
        // TODO: contentInsets 코드 삭제 고려해보기
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 87.5, bottom: 12, trailing: 87.5)
        return configuration
    }()
    
    
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
        
        self.setGlassColor(.glaW10)
        
        exitButton.setImage(.icX, for: .normal)
        
        titleLabel.setLabel(text: StringLiterals.LoginModal.title,
                            style: .h5,
                            color: .acWhite,
                            alignment: .center,
                            numberOfLines: 1)
        
        subTitleLabel.setLabel(text: StringLiterals.LoginModal.subTitle,
                               style: .b1,
                               color: .gray2,
                               alignment: .center,
                        numberOfLines: 2)
        
        googleLoginButton.do {
            $0.configuration = socialLoginButtonConfiguration
            $0.backgroundColor = .gray1
            $0.layer.cornerRadius = 6
//            $0.roundedButton(
//                cornerRadius: 6,
//                maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
//            )
            $0.setImage(.googleLogo, for: .normal)
            $0.setAttributedTitle(text: StringLiterals.Login.googleLogin,
                                  style: .s1,
                                  color: .acBlack)
        }
        
        appleLoginButton.do {
            $0.configuration = socialLoginButtonConfiguration
            $0.backgroundColor = .gray9
            $0.roundedButton(
                cornerRadius: 6,
                maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            )
            $0.setImage(.appleLogo, for: .normal)
            $0.setAttributedTitle(text: StringLiterals.Login.appleLogin,
                                  style: .s1,
                                  color: .acWhite)
        }
        
        youAgreedLabel.do {
            $0.setLabel(text: StringLiterals.Login.youAgreed,
                        style: .b2,
                        color: .gray3,
                        alignment: .center,
                        numberOfLines: 2)
        }
        
        termsStackView.do {
            $0.axis = .horizontal
            $0.spacing = 16
        }
        
        termsOfUseLabel.do {
            $0.setLabel(text: StringLiterals.Login.termsOfUse,
                        style: .b2,
                        color: .gray5)
            $0.setUnderline(
                range: NSRange(location: 0,
                               length: termsOfUseLabel.text?.count ?? 4))
            $0.isUserInteractionEnabled = true
        }
        
        privacyPolicyLabel.do {
            $0.setLabel(text: StringLiterals.Login.privacyPolicy,
                        style: .b2,
                        color: .gray5)
            $0.setUnderline(
                range: NSRange(location: 0,
                               length: privacyPolicyLabel.text?.count ?? 8))
            $0.isUserInteractionEnabled = true
        }
    }
    
}
