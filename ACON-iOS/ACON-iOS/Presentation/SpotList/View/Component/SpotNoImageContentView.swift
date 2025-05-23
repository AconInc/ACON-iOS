//
//  SpotNoImageContentView.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/23/25.
//

import UIKit

class SpotNoImageContentView: BaseView {

    // MARK: - Properties

    let descriptions: Set<String> = [StringLiterals.SpotList.noImageButAconGuarantees,
                                  StringLiterals.SpotList.mysteryPlaceNoImage,
                                  StringLiterals.SpotList.exploreToDiscover]

    let iconImageView = UIImageView()
    let descriptionLabel = UILabel()


    // MARK: - UI Setting Methods

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(iconImageView, descriptionLabel)
    }

    override func setLayout() {
        super.setLayout()

        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(36)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    override func setStyle() {
        self.backgroundColor = .clear

        iconImageView.do {
            $0.image = .icAcornGlass
            $0.contentMode = .scaleAspectFit
        }

        descriptionLabel.do {
            $0.setLabel(text: descriptions.randomElement() ?? "", style: .b1SB, color: .gray50)
        }
    }

}
