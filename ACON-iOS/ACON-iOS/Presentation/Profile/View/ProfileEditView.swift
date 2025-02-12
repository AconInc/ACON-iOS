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
    
    let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    let profileImageEditButton = ProfileImageEditButton(size: 100)
    
    private let nicknameTitleLabel = UILabel()
    
    let nicknameTextField = ProfileEditTextField()
    
    private let nicknameValidMessageView = ProfileEditValidMessageView()
    
    let nicknameLengthLabel = UILabel()
    
    private let birthDateTitleLabel = UILabel()
    
    let birthDateTextField = ProfileEditTextField()
    
    private let birthDateValidMessageView = ProfileEditValidMessageView()
    
    private let verifiedAreaTitleLabel = UILabel()
    
    let verifiedAreaStackView = UIStackView()
    
    let verifiedAreaAddButton = UIButton()
    
    let verifiedAreaBox = LabelBoxWithDeletableButton()
    
    private let verifiedAreaValidMessageView = ProfileEditValidMessageView()
    
    let saveButton = UIButton()
    
    
    // MARK: - LifeCycles
    
    override func setStyle() {
        super.setStyle()
        
        nicknameTitleLabel.setLabel(text: StringLiterals.Profile.nickname, style: .h8)
        
        nicknameTextField.do {
            $0.setPlaceholder(as: StringLiterals.Profile.nicknamePlaceholder)
        }
        
        birthDateTitleLabel.setLabel(text: StringLiterals.Profile.birthDate, style: .h8)
        
        birthDateTextField.do {
            $0.setPlaceholder(as: StringLiterals.Profile.birthDatePlaceholder)
            $0.setDateStyle()
            $0.keyboardType = .numberPad
        }
        
        verifiedAreaTitleLabel.setLabel(text: StringLiterals.Profile.verifiedArea, style: .h8)
        
        verifiedAreaStackView.do {
            $0.axis = .horizontal
        }
        
        verifiedAreaAddButton.do {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .init(top: 12, leading: 12, bottom: 12, trailing: 16)
            config.attributedTitle = AttributedString(StringLiterals.Profile.addVerifiedArea.ACStyle(.s1))
            config.image = .icAdd20
            config.imagePadding = 27
            config.imagePlacement = .trailing
            config.background.cornerRadius = 4
            config.background.strokeColor = .gray5
            config.background.strokeWidth = 1
            $0.configuration = config
        }
        
        saveButton.do {
            var config = UIButton.Configuration.filled()
            config.attributedTitle = AttributedString(StringLiterals.Profile.save.ACStyle(.h7, .gray5))
            config.baseBackgroundColor = .gray7
            $0.configuration = config
        }
        
        saveButton.configurationUpdateHandler = {
            guard var config = $0.configuration else { return }
            config.attributedTitle = AttributedString(
                StringLiterals.Profile.save.ACStyle(.h7, $0.isEnabled ? .acWhite : .gray5)
            )
            $0.configuration = config
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(
            scrollView,
            saveButton
        )
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(
            profileImageEditButton,
            nicknameTitleLabel,
            nicknameTextField,
            nicknameValidMessageView,
            nicknameLengthLabel,
            birthDateTitleLabel,
            birthDateTextField,
            birthDateValidMessageView,
            verifiedAreaTitleLabel,
            verifiedAreaStackView,
            verifiedAreaValidMessageView
        )
        
        verifiedAreaStackView.addArrangedSubviews(
            verifiedAreaAddButton
        )
    }
    
    override func setLayout() {
        super.setLayout()
        
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalTo(scrollView)
            $0.height.greaterThanOrEqualTo(600) // TODO: 디자인 확인
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(12) // TODO: 디자인 확인
            $0.bottom.equalToSuperview().offset(-39)
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
            $0.height.equalTo(52)
        }
        
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
        
        nicknameLengthLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameValidMessageView)
            $0.trailing.equalTo(nicknameValidMessageView)
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
            $0.bottom.equalToSuperview().offset(-sectionOffset)
        }
        
        verifiedAreaStackView.snp.makeConstraints {
            $0.top.equalTo(verifiedAreaTitleLabel.snp.bottom).offset(textFieldOffset)
            $0.leading.equalToSuperview().offset(horizontalInset)
        }
        
        verifiedAreaAddButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(160)
        }
        
        verifiedAreaBox.snp.makeConstraints{
            $0.width.equalTo(160)
            $0.height.equalTo(48)
        }
        
        verifiedAreaValidMessageView.snp.makeConstraints {
            $0.top.equalTo(verifiedAreaStackView.snp.bottom).offset(validMessageOffset)
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
            $0.height.greaterThanOrEqualTo(20)
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
    
    func setNicknameLengthLabel(_ currentLen: Int, _ maxLen: Int) {
        let currentStr = String(currentLen)
        let slashMaxStr = "/\(String(maxLen))"
        nicknameLengthLabel.setPartialText(
            fullText: currentStr + slashMaxStr,
            textStyles: [
                (text: currentStr, style: .s2, color: .acWhite),
                (text: slashMaxStr, style: .s2, color: .gray5)
            ]
        )
    }
    
    func hideVerifiedAreaAddButton(_ isHidden: Bool) {
        verifiedAreaAddButton.isHidden = isHidden
    }
    
    func addVerifiedArea(_ verifiedAreas: [VerifiedAreaModel]) {
        // TODO: 추후 여러 개 추가하는 로직으로 변경(Sprint3)
        let firstAreaName = verifiedAreas.first?.name ?? ""
        verifiedAreaBox.setLabel(firstAreaName)
        verifiedAreaStackView.addArrangedSubview(verifiedAreaBox)
    }
    
    func removeVerifiedArea() {
        verifiedAreaStackView.removeArrangedSubview(verifiedAreaBox)
        verifiedAreaBox.removeFromSuperview()
    }
    
}
