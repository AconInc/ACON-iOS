//
//  ProfileEditValidMessageView.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import UIKit

final class ProfileEditValidMessageView: BaseView {

    // MARK: - UI Properties

    private let iconImageView = UIImageView()

    private let validMessageLabel = UILabel()


    // MARK: - UI Setting Methods

    override func setHierarchy() {
        self.addSubviews(iconImageView, validMessageLabel)
    }

    override func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.size.equalTo(18)
        }

        validMessageLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(4)
            $0.centerY.equalTo(iconImageView)
        }
    }

    override func setStyle() {
        self.isHidden = true
    }



    // MARK: - Internal Methods

    func setValidMessage(_ type: ProfileValidMessageType) {
        switch type {
        case .none:
            self.isHidden = true

        case .nicknameMissing, .nicknameTaken, .invalidDate, .invalidChar:
            self.isHidden = false
            iconImageView.image = .icExclamationMark
            validMessageLabel.setLabel(text: type.text, style: .b1R, color: .labelDanger)

        case .nicknameOK:
            self.isHidden = false
            iconImageView.image = .icSuccess
            validMessageLabel.setLabel(text: type.text, style: .b1R, color: .labelSuccess)
        }
    }

}
