//
//  SpotNoImageContentView.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/23/25.
//

import UIKit

class SpotNoImageContentView: BaseView {

    // MARK: - Properties

    let contentType: ContentType
    let descriptions: Set<String> = [StringLiterals.SpotList.noImageButAconGuarantees,
                                  StringLiterals.SpotList.mysteryPlaceNoImage,
                                  StringLiterals.SpotList.exploreToDiscover]
    let oneLineDescription: String = StringLiterals.SpotList.preparingImage

    let iconImageView = UIImageView()
    let descriptionLabel = UILabel()


    // MARK: - init

    init(_ contentType: ContentType) {
        self.contentType = contentType

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - UI Setting Methods

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(iconImageView, descriptionLabel)
    }

    override func setLayout() {
        super.setLayout()

        switch contentType {
        case .descriptionOnly:
            descriptionLabel.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        case .iconAndDescription:
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
    }

    override func setStyle() {
        self.backgroundColor = .clear

        iconImageView.do {
            $0.image = .icAcornGlass
            $0.contentMode = .scaleAspectFit
        }

        switch contentType {
        case .descriptionOnly:
            descriptionLabel.do {
                $0.setLabel(text: oneLineDescription, style: .b1SB, color: .gray100)
            }
        case .iconAndDescription:
            descriptionLabel.do {
                $0.setLabel(text: descriptions.randomElement() ?? "", style: .b1SB, color: .gray50)
            }
        }
    }

}


// MARK: - Type

extension SpotNoImageContentView {

    enum ContentType {

        case descriptionOnly
        case iconAndDescription

    }

}
