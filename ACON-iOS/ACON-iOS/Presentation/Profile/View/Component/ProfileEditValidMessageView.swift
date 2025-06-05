//
//  ProfileEditValidMessageView.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import UIKit

final class ProfileEditValidMessageView: BaseView {

    // MARK: - UI Properties

    private let icon = UIImageView()

    private let label = UILabel()


    // MARK: - UI Setting Methods

    override func setHierarchy() {
        self.addSubviews(icon, label)
    }

    override func setLayout() {
        icon.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.size.equalTo(18)
        }

        label.snp.makeConstraints {
            $0.leading.equalTo(icon.snp.trailing).offset(4)
            $0.centerY.equalTo(icon)
        }
    }

    override func setStyle() {
        self.isHidden = true
    }

    private func hideFirstLine(_ isHidden: Bool) {
        [icon, label].forEach {
            $0.isHidden = isHidden
        }
    }


    // MARK: - Internal Methods

    func setValidMessage(_ type: ProfileValidMessageType) {
        switch type {
        case .none:
            self.isHidden = true

        case .nicknameMissing, .nicknameTaken, .invalidDate, .invalidChar:
            self.isHidden = false
            icon.image = .icExclamationMark
            label.setLabel(text: type.text, style: .b1R, color: .labelDanger)

        case .nicknameOK:
            self.isHidden = false
            icon.image = .icSuccess
            label.setLabel(text: type.text, style: .b1R, color: .labelSuccess)
        }
    }

}
