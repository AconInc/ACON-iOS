//
//  LoginModalView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/22/25.
//

import UIKit

class LoginModalView: GlassmorphismView {
    
    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    
    private var subTitleLabel  = UILabel()
    
    var googleLoginButton = UIButton()
    
    var appleLoginButton = UIButton()
    
    private let proceedLoginLabel = UILabel()
    
    var termsOfUseLabel = UILabel()
    
    var privacyPolicyLabel = UILabel()
    
    lazy var socialLoginButtonConfiguration: UIButton.Configuration = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .leading
        configuration.imagePadding = 60*ScreenUtils.widthRatio
        configuration.titleAlignment = .center
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 24)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: ScreenUtils.widthRatio*24, bottom: 15, trailing: ScreenUtils.widthRatio*24)
        return configuration
    }()
    
    private let loginButtonHeight: CGFloat = 54
    
    
    // MARK: - Lifecycle
    
    init() {
        // 🍇 TODO: 글모 Type 확인
        super.init(.bottomSheetGlass)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(
            titleLabel,
            subTitleLabel,
            googleLoginButton,
            appleLoginButton,
            proceedLoginLabel,
            termsOfUseLabel,
            privacyPolicyLabel
        )
    }
    
    override func setLayout() {
        super.setLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtils.heightRatio * 57)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8*ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
        }
        
        googleLoginButton.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(ScreenUtils.heightRatio * 120)
            $0.height.equalTo(loginButtonHeight)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*20)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(googleLoginButton.snp.bottom).offset(16 * ScreenUtils.heightRatio)
            $0.height.horizontalEdges.equalTo(googleLoginButton)
        }
        
        proceedLoginLabel.snp.makeConstraints {
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(ScreenUtils.heightRatio * 24)
            $0.centerX.equalToSuperview()
        }

        termsOfUseLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*46)
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*111)
        }
        
        privacyPolicyLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*46)
            $0.trailing.equalToSuperview().inset(ScreenUtils.widthRatio*111)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setHandlerImageView()
        
        titleLabel.setLabel(text: StringLiterals.LoginModal.title,
                            style: .h4SB,
                            color: .acWhite,
                            alignment: .center,
                            numberOfLines: 1)
        
        subTitleLabel.setLabel(text: StringLiterals.LoginModal.subTitle,
                               style: .b1R,
                               color: .gray200,
                               alignment: .center,
                               numberOfLines: 2)
        
        googleLoginButton.do {
            $0.configuration = socialLoginButtonConfiguration
            $0.contentHorizontalAlignment = .leading
            $0.layer.cornerRadius = loginButtonHeight / 2
            $0.backgroundColor = .acWhite
            $0.setImage(.icGoogleLogo, for: .normal)
            $0.setAttributedTitle(text: StringLiterals.Login.googleLogin,
                                  style: .t4SB,
                                  color: .gray500)
        }
        
        appleLoginButton.do {
            $0.configuration = socialLoginButtonConfiguration
            $0.contentHorizontalAlignment = .leading
            $0.layer.cornerRadius = loginButtonHeight / 2
            $0.backgroundColor = .gray900
            $0.setImage(.icAppleLogo, for: .normal)
            $0.setAttributedTitle(text: StringLiterals.Login.appleLogin,
                                  style: .t4SB,
                                  color: .acWhite)
            $0.layer.borderColor = UIColor.gray500.cgColor
            $0.layer.borderWidth = 1
        }
        
        proceedLoginLabel.do {
            $0.setLabel(text: StringLiterals.Login.youAgreed,
                        style: .c1R,
                        color: .acWhite,
                        alignment: .center)
        }
        
        termsOfUseLabel.do {
            $0.setLabel(text: StringLiterals.Login.termsOfUse,
                        style: .c1SB,
                        color: .acWhite,
                        alignment: .center)
            $0.setUnderline(range: NSRange(location: 0, length: termsOfUseLabel.text?.count ?? 4))
            $0.isUserInteractionEnabled = true
        }
        
        privacyPolicyLabel.do {
            $0.setLabel(text: StringLiterals.Login.privacyPolicy,
                        style: .c1SB,
                        color: .acWhite,
                        alignment: .center)
            $0.setUnderline(range: NSRange(location: 0, length: privacyPolicyLabel.text?.count ?? 8))
            $0.isUserInteractionEnabled = true
        }
    }
    
}
