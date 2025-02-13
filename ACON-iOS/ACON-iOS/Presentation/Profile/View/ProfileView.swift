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
    
    private let horizontalInset: CGFloat = 20
    
    private let profileImageSize: CGFloat = 60
    
    private let boxStackSpacing: CGFloat = 8
    
    private let totalAcornCount: Int = 25
    
    
    // MARK: - UI Properties
    
    private let profileImageView = UIImageView()
    
    private let nicknameLabel = UILabel()
    
    var profileEditButton = UIButton()
    
    var needLoginButton = UIButton()
    
    private let boxStackView = UIStackView()
    
    private let acornCountBox = ProfileBoxComponent()
    
    private let verifiedAreaBox = ProfileBoxComponent()
    
    var disableAutoLoginButton = UIButton() // TODO: 삭제
    
    
    // MARK: - Life Cycles
    
    override func setStyle() {
        super.setStyle()
        
        profileImageView.do {
            $0.backgroundColor = .gray7 // NOTE: Skeleton
            $0.layer.cornerRadius = profileImageSize / 2
            $0.contentMode = .scaleAspectFill
        }
        
        profileEditButton.do {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .zero
            config.attributedTitle = AttributedString(StringLiterals.Profile.profileEditButton.ACStyle(.s2, .gray4))
            config.image = .icEditG20
            config.imagePlacement = .trailing
            config.imagePadding = 4
            $0.configuration = config
        }
        
        needLoginButton.do {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .init(top: 15, leading: 0, bottom: 15, trailing: 15)
            config.attributedTitle = AttributedString(StringLiterals.Profile.needLogin.ACStyle(.h5))
            config.image = .icArrowRight28
            config.imagePlacement = .trailing
            config.imagePadding = 2
            config.background.backgroundColor = .gray9
            $0.configuration = config
        }
        
        boxStackView.do {
            $0.axis = .horizontal
            $0.spacing = boxStackSpacing
        }
        
        acornCountBox.setStyle(
            title: StringLiterals.Profile.acornPossession,
            icon: .icLocalAconG20
        )
        
        verifiedAreaBox.do {
            $0.setStyle(
                title: StringLiterals.Profile.myVerifiedArea,
                icon: .icHometownG20
            )
            
            let notVerifiedLabel = UILabel()
            notVerifiedLabel.setLabel(text: StringLiterals.Profile.notVerified,
                           style: .t2,
                           color: .gray5)
            $0.setSecondaryContentView(to: notVerifiedLabel)
        }
        
        disableAutoLoginButton.do { // TODO: 삭제
            $0.setAttributedTitle(text: "자동로그인 해제", style: .b4)
            $0.layer.borderColor = UIColor.acWhite.cgColor
            $0.layer.borderWidth = 0.5
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(
            profileImageView,
            nicknameLabel,
            profileEditButton,
            needLoginButton,
            boxStackView,
            disableAutoLoginButton // TODO: 삭제
        )
        
        boxStackView.addArrangedSubviews(
            acornCountBox,
            verifiedAreaBox
        )
    }
    
    override func setLayout() {
        super.setLayout()
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(horizontalInset)
            $0.size.equalTo(profileImageSize)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView).offset(4)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-horizontalInset)
        }
        
        profileEditButton.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(nicknameLabel)
        }
        
        needLoginButton.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel)
            $0.centerY.equalTo(profileImageView)
        }
        
        boxStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
        }
        
        acornCountBox.snp.makeConstraints {
            $0.width.equalTo(
                (ScreenUtils.width - horizontalInset * 2 - boxStackSpacing) / 2
            )
            $0.height.equalTo(94)
        }
        
        verifiedAreaBox.snp.makeConstraints {
            $0.width.equalTo(
                (ScreenUtils.width - horizontalInset * 2 - boxStackSpacing) / 2
            )
            $0.height.equalTo(94)
        }
        
        disableAutoLoginButton.snp.makeConstraints { // TODO: 삭제
            $0.bottom.equalToSuperview().inset(100)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(100)
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
    
    func setAcornCountBox(_ possessingCount: Int) {
        let acornCountabel = UILabel()
        let possessingString = possessingCount == 0 ? "00" : String(possessingCount)
        // TODO: partialText 가운데 정렬 되도록 수정 (바닥 정렬인 partialText도 있어서 메소드 하나 더 만들어야 할 듯)
        acornCountabel.setPartialText(
            fullText: "\(possessingString)/\(String(totalAcornCount))",
            textStyles: [
                (text: possessingString, style: .t2, color: .org1),
                (text: "/\(String(totalAcornCount))", style: .s2, color: .gray5)
            ]
        )
        
        acornCountBox.setContentView(to: acornCountabel)
    }
    
    func setVerifiedAreaBox(areaName: String) {
        let label = UILabel()
        label.setLabel(text: areaName,
                       style: .t2,
                       color: .org1)
        
        verifiedAreaBox.setContentView(to: label)
    }
    
    func setVerifiedAreaBox(onLoginSuccess: Bool) {
        verifiedAreaBox.switchContentView(toSecondary: !onLoginSuccess)
    }
    
}
