//
//  OpeningTimeView.swift
//  ACON-iOS
//
//  Created by 김유림 on 6/8/25.
//

import UIKit

class OpeningTimeView: BaseView {

    // MARK: - Data

    private var startTime: String? = nil
    private var endTime: String? = nil
    private let withDot: Bool


    // MARK: - UI Properties

    private let dotImageView = UIImageView()

    private let timeLabel = UILabel()

    private let descriptionLabel = UILabel()


    // MARK: - Initializer

    init(startTime: String, withDot: Bool) {
        self.startTime = startTime
        self.withDot = withDot

        super.init(frame: .zero)
    }

    init(endTime: String, withDot: Bool) {
        self.endTime = endTime
        self.withDot = withDot

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

        if withDot {
            dotImageView.snp.makeConstraints {
                $0.leading.centerY.equalToSuperview()
                $0.size.equalTo(24)
            }
            
            timeLabel.snp.makeConstraints {
                $0.leading.equalTo(dotImageView.snp.trailing).offset(-2)
                $0.centerY.equalTo(dotImageView)
            }
        } else {
            timeLabel.snp.makeConstraints {
                $0.leading.centerY.equalToSuperview()
            }
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(timeLabel.snp.trailing).offset(4)
            $0.trailing.equalToSuperview()
        }
    }

    override func setStyle() {
        self.backgroundColor = .clear

        if let startTime = startTime {
            dotImageView.do {
                $0.image = .icGraylight
                $0.contentMode = .scaleAspectFit
            }
            timeLabel.setLabel(text: startTime, style: .b1SB, color: .gray200)
            descriptionLabel.setLabel(text: StringLiterals.SpotList.businessStart, style: .b1R, color: .gray200)
        }

        else if let endTime = endTime {
            dotImageView.image = .icGreenlight
            timeLabel.setLabel(text: endTime, style: .b1SB, color: .gray200)
            descriptionLabel.setLabel(text: StringLiterals.SpotList.businessEnd, style: .b1R, color: .gray200)
        }
    }

}
