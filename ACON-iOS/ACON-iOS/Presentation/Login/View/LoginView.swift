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
    
    private let brandingLabel : UILabel = UILabel()
    
    private let logoImageView : UIImageView = UIImageView()
    
    var googleLoginButton: UIButton = UIButton()
    
    var appleLoginButton: UIButton = UIButton()
    
    private let proceedLoginLabel: UILabel = UILabel()
    
    var termsOfUseLabel: UILabel = UILabel()
    
    var privacyPolicyLabel: UILabel = UILabel()
    
    lazy var socialLoginButtonConfiguration: UIButton.Configuration = {
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
        
        self.addSubviews(brandingLabel,
                         logoImageView,
                         googleLoginButton,
                         appleLoginButton,
                         proceedLoginLabel,
                         termsOfUseLabel,
                         privacyPolicyLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtils.heightRatio*145)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.heightRatio*91)
            $0.width.equalTo(ScreenUtils.widthRatio*261)
        }
        
        googleLoginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*172)
            $0.height.equalTo(loginButtonHeight)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*20)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(googleLoginButton.snp.bottom).offset(8)
            $0.height.equalTo(loginButtonHeight)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*20)
        }
        
        proceedLoginLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*60)
            $0.centerX.equalToSuperview()
        }
        
        termsOfUseLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*36)
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*111.5)
        }
        
        privacyPolicyLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*36)
            $0.trailing.equalToSuperview().inset(ScreenUtils.widthRatio*111.5)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        logoImageView.do {
            $0.image = .icWordLogoSplashOrg
            $0.contentMode = .scaleAspectFit
        }
        
        googleLoginButton.do {
            $0.configuration = socialLoginButtonConfiguration
            $0.contentHorizontalAlignment = .leading
            $0.layer.cornerRadius = loginButtonHeight / 2
            $0.backgroundColor = .gray100
            $0.setImage(.icGoogle, for: .normal)
            $0.setAttributedTitle(text: StringLiterals.Login.googleLogin,
                                  style: .t4(.semibold),
                                  color: .gray500)
        }
        
        appleLoginButton.do {
            $0.configuration = socialLoginButtonConfiguration
            $0.contentHorizontalAlignment = .leading
            $0.layer.cornerRadius = loginButtonHeight / 2
            $0.backgroundColor = .acBlack
            $0.setImage(.icApple, for: .normal)
            $0.setAttributedTitle(text: StringLiterals.Login.appleLogin,
                                  style: .t4(.semibold),
                                  color: .acWhite)
            $0.layer.borderColor = UIColor.gray500.cgColor
            $0.layer.borderWidth = 1
        }
        
        proceedLoginLabel.do {
            $0.setLabel(text: StringLiterals.Login.youAgreed,
                        style: .c1(.regular),
                        color: .acWhite,
                        alignment: .center)
        }
        
        termsOfUseLabel.do {
            $0.setLabel(text: StringLiterals.Login.termsOfUse,
                        style: .c1(.semibold),
                        color: .acWhite,
                        alignment: .center)
            $0.setUnderline(range: NSRange(location: 0, length: termsOfUseLabel.text?.count ?? 4))
            $0.isUserInteractionEnabled = true
        }
        
        privacyPolicyLabel.do {
            $0.setLabel(text: StringLiterals.Login.privacyPolicy,
                        style: .c1(.semibold),
                        color: .acWhite,
                        alignment: .center)
            $0.setUnderline(range: NSRange(location: 0, length: privacyPolicyLabel.text?.count ?? 8))
            $0.isUserInteractionEnabled = true
        }
    }
    
}
