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
    
    // MARK: - Helpers
    
    private let horizontalInset: CGFloat = 20
    
    private let profileImageSize: CGFloat = 60
    
    private let boxStackSpacing: CGFloat = 8
    
    private let totalAcornCount: Int = 25
    
    
    // MARK: - UI Components
    
    private let profileImageView = UIImageView()
    
    private let usernameLabel = UILabel()
    
    var profileEditButton = UIButton()
    
    var needLoginButton = UIButton()
    
    private let boxStackView = UIStackView()
    
    private let acornCountBox = ProfileBoxComponent()
    
    private let verifiedAreaBox = ProfileBoxComponent()
    
    
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
        
        verifiedAreaBox.setStyle(
            title: StringLiterals.Profile.verifiedArea,
            icon: .icHometownG20
        )
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(
            profileImageView,
            usernameLabel,
            profileEditButton,
            needLoginButton,
            boxStackView
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
        
        usernameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView).offset(4)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-horizontalInset)
        }
        
        profileEditButton.snp.makeConstraints {
            $0.top.equalTo(usernameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(usernameLabel)
        }
        
        needLoginButton.snp.makeConstraints {
            $0.leading.equalTo(usernameLabel)
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
    }
    
    
    // MARK: - Internal Methods
    
    func setAcornCountBox(_ possessingCount: Int) {
        let acornCountabel = UILabel()
        let possessingString = possessingCount == 0 ? "00" : String(possessingCount)
        // TODO: partialText 가운데 정렬 되도록 수정
        acornCountabel.setPartialText(
            fullText: "\(possessingString)/\(String(totalAcornCount))",
            textStyles: [
                (text: possessingString, style: .t2, color: .org1),
                (text: "/\(String(totalAcornCount))", style: .s2, color: .gray5)
            ]
        )
        
        acornCountBox.setContentView(to: acornCountabel)
    }
    
    func setVerifiedAreaBox(_ areaName: String) {
        let label = UILabel()
        label.setLabel(text: areaName, style: .t2, color: .org1)
        
        verifiedAreaBox.setContentView(to: label)
    }
    
}
