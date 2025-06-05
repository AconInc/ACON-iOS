//
//  ProfileEditView.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import UIKit

final class ProfileEditView: BaseView {

    // MARK: - Helpers

    private let textFieldHeight: CGFloat = 48

    private let sectionOffset: CGFloat = 160

    private let textFieldOffset: CGFloat = 12

    private let validMessageOffset: CGFloat = 8


    // MARK: - UI Components

    let scrollView = UIScrollView()

    private let contentView = UIView()

    let profileImageEditButton = ProfileImageEditButton(size: 100)

    private let nicknameTitleLabel = UILabel()
    
    let nicknameTextField = ACTextField(cornerRadius: 8, fontStyle: .b1R, borderGlassType: .buttonGlassDefault)
    
    private let nicknameValidMessageView = ProfileEditValidMessageView()

    let nicknameLengthLabel = UILabel()

    private let birthDateTitleLabel = UILabel()
    
    let birthDateTextField = ACTextField(cornerRadius: 8, fontStyle: .b1R, borderGlassType: .buttonGlassDefault)
    
    private let birthDateValidMessageView = ProfileEditValidMessageView()

    let saveButton: ACButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_12_t4SB), title: StringLiterals.Profile.save)


    // MARK: - UI Setting Methods

    override func setStyle() {
        super.setStyle()

        nicknameTitleLabel.setPartialText(
            fullText: StringLiterals.Profile.nickname + StringLiterals.Profile.neccessaryStarWithSpace,
            textStyles: [
                (text: StringLiterals.Profile.nickname, style: .t4SB, color: .acWhite),
                (text: StringLiterals.Profile.neccessaryStarWithSpace, style: .t4SB, color: .primaryDefault)
            ]
        )

        nicknameTextField.do {
            $0.setPlaceholder(as: StringLiterals.Profile.nicknamePlaceholder)
            $0.textField.autocapitalizationType = .none
        }

        birthDateTitleLabel.setLabel(text: StringLiterals.Profile.birthDate, style: .t4SB)

        birthDateTextField.do {
            $0.setPlaceholder(as: StringLiterals.Profile.birthDatePlaceholder)
            $0.setAsDateField()
            $0.textField.keyboardType = .numberPad
        }

        saveButton.do {
            $0.updateGlassButtonState(state: .disabled)
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
            birthDateValidMessageView
        )
    }

    override func setLayout() {
        super.setLayout()

        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.width.equalTo(scrollView)
            $0.height.greaterThanOrEqualTo(380)
        }

        saveButton.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(ScreenUtils.horizontalInset)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(ScreenUtils.horizontalInset)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.height.equalTo(54)
        }

        profileImageEditButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(19)
            $0.centerX.equalToSuperview()
        }

        nicknameTitleLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageEditButton.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(ScreenUtils.horizontalInset)
        }

        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameTitleLabel.snp.bottom).offset(textFieldOffset)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.height.greaterThanOrEqualTo(textFieldHeight)
        }

        nicknameValidMessageView.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(validMessageOffset)
            $0.horizontalEdges.equalToSuperview().inset(24 * ScreenUtils.widthRatio)
            $0.height.greaterThanOrEqualTo(44)
        }

        nicknameLengthLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameValidMessageView)
            $0.trailing.equalToSuperview().inset(24 * ScreenUtils.widthRatio)
        }

        birthDateTitleLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTitleLabel).offset(sectionOffset)
            $0.leading.equalToSuperview().offset(ScreenUtils.horizontalInset)
        }

        birthDateTextField.snp.makeConstraints {
            $0.top.equalTo(birthDateTitleLabel.snp.bottom).offset(textFieldOffset)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.height.greaterThanOrEqualTo(textFieldHeight)
        }

        birthDateValidMessageView.snp.makeConstraints {
            $0.top.equalTo(birthDateTextField.snp.bottom).offset(validMessageOffset)
            $0.horizontalEdges.equalToSuperview().inset(24 * ScreenUtils.widthRatio)
            $0.height.greaterThanOrEqualTo(20)
        }
    }


    // MARK: - Internal Methods

    func setProfileImage(_ image: UIImage) {
        profileImageEditButton.setImage(image)
    }

    func setProfileImageURL(_ imageURL: String) {
        profileImageEditButton.setImageURL(imageURL)
    }

    func setNicknameValidMessage(_ type: ProfileValidMessageType) {
        nicknameValidMessageView.setValidMessage(type)
    }

    func setBirthdateValidMessage(_ type: ProfileValidMessageType) {
        birthDateValidMessageView.setValidMessage(type)
    }

    func setNicknameLengthLabel(_ currentLen: Int, _ maxLen: Int) {
        let currentStr = String(currentLen)
        let slashMaxStr = "/\(String(maxLen))"
        nicknameLengthLabel.setLabel(text: currentStr + slashMaxStr, style: .c1R, color: .gray500)
    }

}
