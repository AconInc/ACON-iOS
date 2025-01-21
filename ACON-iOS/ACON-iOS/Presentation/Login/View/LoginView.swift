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
    
    private var logoLabel : UILabel = UILabel()
    
    var googleLoginButton: UIButton = UIButton()
    
    var appleLoginButton: UIButton = UIButton()
    
    private let proceedLoginLabel: UILabel = UILabel()
    
    var termsOfUseLabel: UILabel = UILabel()
    
    var privacyPolicyLabel: UILabel = UILabel()
    
    var socialLoginButtonConfiguration: UIButton.Configuration = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .leading
        configuration.imagePadding = 4
        configuration.titleAlignment = .center
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 24)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 93, bottom: 12, trailing: 93)
        return configuration
    }()
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(brandingLabel,
                         logoImageView,
                         googleLoginButton,
                         appleLoginButton,
                         proceedLoginLabel,
                         termsOfUseLabel,
                         privacyPolicyLabel,
                         logoLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtils.heightRatio*145)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.heightRatio*91)
            $0.width.equalTo(ScreenUtils.widthRatio*261)
        }
        
        logoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtils.heightRatio*244)
            $0.centerX.equalToSuperview()
        }
        
        googleLoginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*172/780)
            $0.height.equalTo(ScreenUtils.height*50/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(googleLoginButton.snp.bottom).offset(8)
            $0.height.equalTo(ScreenUtils.height*50/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
        }
        
        proceedLoginLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*90/780)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(276)
        }
        
        termsOfUseLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*72/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*115.5/360)
            $0.width.equalTo(38)
        }
        
        privacyPolicyLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*72/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*169.5/360)
            $0.width.equalTo(75)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        logoImageView.do {
            $0.image = .aconLogo
            $0.contentMode = .scaleAspectFit
        }
        
        logoLabel.do {
            $0.setLabel(text: StringLiterals.Login.logoText,
                        style: .h7,
                        color: .acWhite,
                        alignment: .center,
                        numberOfLines: 2)
        }
        
        googleLoginButton.do {
            $0.configuration = socialLoginButtonConfiguration
            $0.backgroundColor = .gray1
            $0.roundedButton(cornerRadius: 6, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
            $0.setImage(.googleLogo, for: .normal)
            $0.setAttributedTitle(text: StringLiterals.Login.googleLogin,
                                  style: .s2,
                                  color: .acBlack)
        }
        
        appleLoginButton.do {
            $0.configuration = socialLoginButtonConfiguration
            $0.backgroundColor = .gray9
            $0.roundedButton(cornerRadius: 6, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
            $0.setImage(.appleLogo, for: .normal)
            $0.setAttributedTitle(text: StringLiterals.Login.appleLogin,
                                  style: .s2,
                                  color: .acWhite)
    
        }
        
        proceedLoginLabel.do {
            $0.setLabel(text: StringLiterals.Login.youAgreed,
                        style: .c1,
                        color: .gray3)
        }
        
        termsOfUseLabel.do {
            $0.setLabel(text: StringLiterals.Login.termsOfUse,
                        style: .c1,
                        color: .gray5)
            $0.setUnderline(range: NSRange(location: 0, length: termsOfUseLabel.text?.count ?? 4))
        }
        
        privacyPolicyLabel.do {
            $0.setLabel(text: StringLiterals.Login.privacyPolicy,
                        style: .c1,
                        color: .gray5)
            $0.setUnderline(range: NSRange(location: 0, length: privacyPolicyLabel.text?.count ?? 8))
        }
    }
    
}
