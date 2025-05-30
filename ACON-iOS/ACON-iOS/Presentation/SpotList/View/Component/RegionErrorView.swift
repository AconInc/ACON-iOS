//
//  RegionErrorView.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/30/25.
//

import UIKit

class RegionErrorView: BaseView {

    // MARK: - UI Properties

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()


    // MARK: - UI Setting Methods

    override func setHierarchy() {
        self.addSubviews(titleLabel,
                         descriptionLabel)
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24 + ScreenUtils.navViewHeight)
            $0.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }

    override func setStyle() {
        backgroundColor = .clear

        titleLabel.setLabel(text: StringLiterals.SpotList.unsupportedRegion, style: .t2SB, alignment: .center)

        descriptionLabel.setLabel(text: StringLiterals.SpotList.unsupportedRegionPleaseRetry, style: .b1R, color: .gray500)
    }

}
