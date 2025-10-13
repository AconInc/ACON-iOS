//
//  LoginView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/11/25.
//

import UIKit

import SnapKit
import Then

final class LoginView: BaseView {
    
    // MARK: - UI Properties
    
    private let logoImageView : UIImageView = UIImageView()
    
    private let shadowImageView: UIImageView = UIImageView()
    
    let loginContentView: UIView = UIView()
    
    var googleLoginButton: UIButton = UIButton()
    
    var appleLoginButton: ACButton = ACButton(style: GlassConfigButton(buttonType: .line_12_b1SB))
    
    private let proceedLoginLabel: UILabel = UILabel()
    
    var termsOfUseLabel: UILabel = UILabel()
    
    var privacyPolicyLabel: UILabel = UILabel()
    
    lazy var socialLoginButtonConfiguration: UIButton.Configuration = {
        var configuration = UIButton.Configuration.filled()
        configuration.imagePlacement = .leading
        configuration.imagePadding = 60*ScreenUtils.widthRatio
        configuration.titleAlignment = .center
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 24)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: ScreenUtils.widthRatio*24, bottom: 15, trailing: ScreenUtils.widthRatio*24)
        configuration.cornerStyle = .capsule
        return configuration
    }()
    
    private let loginButtonHeight: CGFloat = 54
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(loginContentView,
                         logoImageView,
                         shadowImageView)
        loginContentView.addSubviews(googleLoginButton,
                                     appleLoginButton,
                                     proceedLoginLabel,
                                     termsOfUseLabel,
                                     privacyPolicyLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        loginContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*416)
            $0.width.equalTo(ScreenUtils.widthRatio*240)
            $0.height.equalTo(ScreenUtils.heightRatio*120)
            $0.centerX.equalToSuperview()
        }
        
        shadowImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*340)
            $0.centerX.equalToSuperview()
        }
        
        googleLoginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*177)
            $0.height.equalTo(loginButtonHeight)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*20)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(googleLoginButton.snp.bottom).offset(16)
            $0.height.equalTo(loginButtonHeight)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*20)
        }
        
        proceedLoginLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*65)
            $0.centerX.equalToSuperview()
        }
        
        termsOfUseLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*45)
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*111)
        }
        
        privacyPolicyLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*45)
            $0.trailing.equalToSuperview().inset(ScreenUtils.widthRatio*111)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        loginContentView.do {
            $0.backgroundColor = .clear
        }
        
        logoImageView.do {
            $0.image = .imgSplash
            $0.contentMode = .scaleAspectFit
        }
        
        shadowImageView.do {
            $0.image = .imgSplashShadow
            $0.contentMode = .scaleAspectFit
        }
        
        googleLoginButton.do {
            var config = socialLoginButtonConfiguration
            config.background.backgroundColor = .acWhite
            config.image = .icGoogleLogo
            config.attributedTitle = AttributedString(StringLiterals.Login.googleLogin.attributedString(.t4SB, .gray500))
            $0.configuration = config
            $0.contentHorizontalAlignment = .leading
        }
        
        appleLoginButton.do {
            var config = socialLoginButtonConfiguration
            config.baseBackgroundColor = .gray700
            config.image = .icAppleLogo
            config.attributedTitle = AttributedString(StringLiterals.Login.appleLogin.attributedString(.t4SB, .acWhite))
            $0.configuration = config
            $0.contentHorizontalAlignment = .leading
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
