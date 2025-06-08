//
//  OpeningTimeView.swift
//  ACON-iOS
//
//  Created by 김유림 on 6/8/25.
//

import UIKit

class OpeningTimeView: BaseView {

    // MARK: - Data

    private let timeType: OpeningTimeType
    private var time: String
    private let withDot: Bool


    // MARK: - UI Properties

    private let dotImageView = UIImageView()

    private let timeLabel = UILabel()

    private let descriptionLabel = UILabel()


    // MARK: - Initializer

    init(type: OpeningTimeType, time: String, withDot: Bool) {
        self.timeType = type
        self.time = time
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
                $0.leading.equalToSuperview().offset(-6)
                $0.centerY.equalToSuperview()
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

        dotImageView.do {
            $0.image = timeType.dotImage
            $0.contentMode = .scaleAspectFit
        }

        timeLabel.setLabel(text: time, style: .b1SB, color: .gray200)

        descriptionLabel.setLabel(text: timeType.description, style: .b1R, color: .gray200)
    }

}


// MARK: - enum

extension OpeningTimeView {

    enum OpeningTimeType {
        case start, end

        var dotImage: UIImage {
            switch self {
            case .start: return .icGraylight
            case .end: return .icGreenlight
            }
        }

        var description: String {
            switch self {
            case .start: return StringLiterals.SpotList.businessStart
            case .end: return StringLiterals.SpotList.businessEnd
            }
        }
    }

}
