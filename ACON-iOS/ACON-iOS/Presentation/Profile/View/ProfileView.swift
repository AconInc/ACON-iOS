//
//  ProfileView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/17/25.
//

import UIKit

import Then
import SnapKit

final class ProfileView: BaseView {
    
    // MARK: - Sizes
    
    private let horizontalInset: CGFloat = 20
    
    private let profileImageSize: CGFloat = 60
    
    
    // MARK: - UI Components
    
    private let profileImageView = UIImageView()
    
    private let usernameLabel = UILabel()
    
    var profileEditButton = UIButton()
    
//    var disableAutoLoginButton = UIButton()
    
    
    // MARK: - LifeCycles
    
    override func setStyle() {
        super.setStyle()
        
        self.backgroundColor = .gray9
        
        profileImageView.do {
            $0.image = .imgProfileBasic60
            $0.layer.cornerRadius = profileImageSize / 2
        }
        
        // TODO: Username 바인딩
        usernameLabel.setLabel(text: "UserName", style: .h5)
        
        profileEditButton.do {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .zero
            config.attributedTitle = AttributedString(StringLiterals.Profile.editProfile.ACStyle(.s2, .gray4))
            config.image = .icEditG20
            config.imagePlacement = .trailing
            config.imagePadding = 4
            $0.configuration = config
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(
            profileImageView,
            usernameLabel,
            profileEditButton
        )
    }
    
    override func setLayout() {
        super.setLayout()
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(horizontalInset)
            $0.size.equalTo(profileImageSize)
        }
        
        usernameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView).offset(4)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-horizontalInset)
        }
        
        profileEditButton.snp.makeConstraints {
            $0.top.equalTo(usernameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(usernameLabel)
        }
    }
    
}
