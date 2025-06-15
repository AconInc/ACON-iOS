//
//  OpeningTimeView.swift
//  ACON-iOS
//
//  Created by 김유림 on 6/8/25.
//

import UIKit

class OpeningTimeView: BaseView {

    // MARK: - Data

    private var isOpen: Bool

    private var time: String

    private var openingDescription: String


    // MARK: - UI Properties

    private let dotImageView = UIImageView()

    private let timeLabel = UILabel()

    private let descriptionLabel = UILabel()


    // MARK: - Initializer

    init(isOpen: Bool, time: String, description: String) {
        self.isOpen = isOpen
        self.time = time
        self.openingDescription = description

        super.init(frame: .zero)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - UI Setup

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(dotImageView, timeLabel, descriptionLabel)
    }

    override func setLayout() {
        super.setLayout()

        self.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(24)
        }

        dotImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(-6)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(dotImageView.snp.trailing).offset(-2)
            $0.centerY.equalTo(dotImageView)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(timeLabel.snp.trailing).offset(4)
            $0.trailing.equalToSuperview()
        }
    }

    override func setStyle() {
        self.backgroundColor = .clear

        dotImageView.do {
            $0.image = isOpen ? .icGreenlight : .icGraylight
            $0.contentMode = .scaleAspectFit
        }

        timeLabel.setLabel(text: time, style: .b1SB, color: .gray200)

        descriptionLabel.setLabel(text: openingDescription, style: .b1R, color: .gray200)
    }

    func updateUI(isOpen: Bool, time: String, description: String) {
        dotImageView.do {
            $0.image = isOpen ? .icGreenlight : .icGraylight
        }

        timeLabel.setLabel(text: time, style: .b1SB, color: .gray200)

        descriptionLabel.setLabel(text: openingDescription, style: .b1R, color: .gray200)
    }

}
