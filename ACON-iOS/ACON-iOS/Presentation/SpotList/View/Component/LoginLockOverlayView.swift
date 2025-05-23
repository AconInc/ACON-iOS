//
//  LoginLockOverlayView.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/20/25.
//

import UIKit

class LoginLockOverlayView: GlassmorphismView {

    // MARK: - UI Properties

    private let contentView = UIView()

    private let iconImageView = UIImageView()

    private let descriptionLabel = UILabel()

    private let actionLabel = UILabel()


    // MARK: - Init

    init() {
        super.init(.needLoginErrorGlass)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - UI Setting Methods

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(contentView)

        contentView.addSubviews(
            iconImageView,
            descriptionLabel,
            actionLabel
        )
    }

    override func setLayout() {
        super.setLayout()

        contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        iconImageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(24)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(10)
            $0.centerX.equalTo(iconImageView)
        }

        actionLabel.snp.makeConstraints{
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
            $0.centerX.equalTo(iconImageView)
        }
    }

    override func setStyle() {
        super.setStyle()

        iconImageView.do {
            $0.image = .icLock
            $0.contentMode = .scaleAspectFit
        }

        descriptionLabel.setLabel(text: StringLiterals.SpotList.needLoginToSeeMore,
                                  style: .b1R,
                                  color: .gray200,
                                  alignment: .center)

        actionLabel.setLabel(
            text: StringLiterals.SpotList.loginInThreeSeconds,
            style: .b1SB,
            color: .labelAction)
    }

}
