//
//  ProfileView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/17/25.
//

import UIKit

import Kingfisher
import Then
import SnapKit

final class ProfileView: BaseView {

    // MARK: - Helpers

    private let horizontalInset: CGFloat = ScreenUtils.widthRatio*16

    private let profileImageSize: CGFloat = 60


    // MARK: - UI Properties

    private let profileImageView = UIImageView()

    private let nicknameLabel = UILabel()

    let profileEditButton = UIButton()

    let needLoginButton = UIButton()
    

    // MARK: - UI Setting Methods

    override func setStyle() {
        super.setStyle()
        
        profileImageView.do {
            $0.backgroundColor = .gray700 // NOTE: Skeleton
            $0.layer.cornerRadius = profileImageSize / 2
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.image = .imgProfileBasic
        }

        profileEditButton.do {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .zero
            config.attributedTitle = AttributedString(StringLiterals.Profile.profileEditButton.attributedString(.b1R, .gray500))
            config.image = .icEditG
            config.imagePlacement = .trailing
            config.imagePadding = 4
            $0.configuration = config
        }

        needLoginButton.do {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .init(top: 15, leading: 0, bottom: 15, trailing: 15)
            config.attributedTitle = AttributedString(StringLiterals.Profile.needLogin.attributedString(.h4SB))
            config.image = .icArrowRight
            config.imagePlacement = .trailing
            config.imagePadding = 2
            config.background.backgroundColor = .gray900
            $0.configuration = config
        }
    }

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(
            profileImageView,
            nicknameLabel,
            profileEditButton,
            needLoginButton
        )
    }

    override func setLayout() {
        super.setLayout()

        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40*ScreenUtils.heightRatio)
            $0.leading.equalToSuperview().offset(horizontalInset)
            $0.size.equalTo(profileImageSize)
        }

        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView).offset(4)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(horizontalInset)
        }

        profileEditButton.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(nicknameLabel)
        }

        needLoginButton.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel)
            $0.centerY.equalTo(profileImageView)
        }
    }

}


// MARK: - Internal Methods

extension ProfileView {

    func setProfileImage(_ imageURL: String) {
        profileImageView.kf.setImage(
            with: URL(string: imageURL),
            options: [.transition(.none), .cacheOriginalImage]
        )
    }

    func setNicknameLabel(_ text: String) {
        nicknameLabel.setLabel(text: text, style: .h5)
    }
    
}
