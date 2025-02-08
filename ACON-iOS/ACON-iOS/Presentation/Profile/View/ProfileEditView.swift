//
//  ProfileEditView.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import UIKit

class ProfileEditView: BaseView {
    
    // MARK: - Helpers
    
    private let horizontalInset: CGFloat = 20
    
    private let textFieldHeight: CGFloat = 48
    
    private let sectionOffset: CGFloat = 160
    
    private let textFieldOffset: CGFloat = 12
    
    private let validMessageOffset: CGFloat = 8
    
    
    // MARK: - UI Components
    
    // TODO: ScrollView로 감싸기
    
    private let profileImageEditButton = ProfileImageEditButton(size: 100)
    
    private let nicknameTitleLabel = UILabel()
    
    var nicknameTextField = ProfileEditTextField()
    
    var nicknameValidMessageView = ProfileEditValidMessageView()
    
    private let birthDateTitleLabel = UILabel()
    
    var birthDateTextField = ProfileEditTextField()
    
    var birthDateValidMessageView = ProfileEditValidMessageView()
    
    private let verifiedAreaTitleLabel = UILabel()
    
    var verifiedAreaStackView = UIStackView()
    
    var verifiedAreaValidMessageView = ProfileEditValidMessageView()
    
    var saveButton = UIButton()
    
    
    // MARK: - LifeCycles
    
    override func setStyle() {
        super.setStyle()
        
        nicknameTitleLabel.setLabel(text: "닉네임", style: .h8)
        
        nicknameTextField.do {
            $0.setStyle(placeholder: StringLiterals.Profile.nicknamePlaceholder)
        }
        
        birthDateTitleLabel.setLabel(text: "생년월일", style: .h8)
        
        birthDateTextField.do {
            $0.setStyle(placeholder: StringLiterals.Profile.birthDatePlaceholder)
        }
        
        verifiedAreaTitleLabel.setLabel(text: "인증동네", style: .h8)
        
        verifiedAreaStackView.do {
            $0.backgroundColor = .blue2
        }
        
        saveButton.do {
            var config = UIButton.Configuration.filled()
            config.attributedTitle = AttributedString("저장".ACStyle(.h7))
            config.baseBackgroundColor = .gray7
            config.baseForegroundColor = .gray5
            $0.configuration = config
        }
        
        saveButton.configurationUpdateHandler = {
            guard var config = $0.configuration else { return }
            config.baseForegroundColor = $0.isEnabled ? .acWhite : .gray5
            $0.configuration = config
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(
            profileImageEditButton,
            nicknameTitleLabel,
            nicknameTextField,
            nicknameValidMessageView,
            birthDateTitleLabel,
            birthDateTextField,
            birthDateValidMessageView,
            verifiedAreaTitleLabel,
            verifiedAreaStackView,
            verifiedAreaValidMessageView,
            saveButton
        )
    }
    
    override func setLayout() {
        super.setLayout()
        
        profileImageEditButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        }
        
        nicknameTitleLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageEditButton.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(horizontalInset)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameTitleLabel.snp.bottom).offset(textFieldOffset)
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
            $0.height.greaterThanOrEqualTo(textFieldHeight)
        }
        
        nicknameValidMessageView.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(validMessageOffset)
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
            $0.height.greaterThanOrEqualTo(44)
        }
        
        birthDateTitleLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTitleLabel).offset(sectionOffset)
            $0.leading.equalToSuperview().offset(horizontalInset)
        }
        
        birthDateTextField.snp.makeConstraints {
            $0.top.equalTo(birthDateTitleLabel.snp.bottom).offset(textFieldOffset)
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
            $0.height.greaterThanOrEqualTo(textFieldHeight)
        }
        
        birthDateValidMessageView.snp.makeConstraints {
            $0.top.equalTo(birthDateTextField.snp.bottom).offset(validMessageOffset)
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
            $0.height.greaterThanOrEqualTo(20)
        }
        
        verifiedAreaTitleLabel.snp.makeConstraints {
            $0.top.equalTo(birthDateTitleLabel).offset(sectionOffset)
            $0.leading.equalToSuperview().offset(horizontalInset)
        }
        
        verifiedAreaStackView.snp.makeConstraints {
            $0.top.equalTo(verifiedAreaTitleLabel.snp.bottom).offset(textFieldOffset)
            $0.leading.equalToSuperview().offset(horizontalInset)
        }
        
        verifiedAreaValidMessageView.snp.makeConstraints {
            $0.top.equalTo(verifiedAreaStackView.snp.bottom).offset(validMessageOffset)
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
            $0.height.greaterThanOrEqualTo(20)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-39)
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
            $0.height.equalTo(52)
        }
    }
    
    
    // MARK: - Internal Methods
    
    func setProfileImage(_ imageURL: String) {
        profileImageEditButton.setImage(imageURL)
    }
    
    func setNicknameValidMessage(_ type: ProfileValidMessageType) {
        nicknameValidMessageView.setValidMessage(type)
    }
    
    func setBirthdateValidMessage(_ type: ProfileValidMessageType) {
        birthDateValidMessageView.setValidMessage(type)
    }
    
    func setVerifiedAreaValidMessage(_ type: ProfileValidMessageType) {
        verifiedAreaValidMessageView.setValidMessage(type)
    }
    
}
