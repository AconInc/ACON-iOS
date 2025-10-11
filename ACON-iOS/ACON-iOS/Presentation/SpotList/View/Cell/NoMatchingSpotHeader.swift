//
//  RequestToAddHeader.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/24/25.
//

import UIKit

class NoMatchingSpotHeader: UICollectionReusableView {

    // MARK: - UI Properties

    private let noMatchingSpotLabel = UILabel()
    private let sorryLabel = UILabel()

    private let willSuggestNextTimeLabel = UILabel()
    let registerSpotButton = UIButton()

    private let howAboutTheseLabel = UILabel()


    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setHierarchy() {
        self.addSubviews(noMatchingSpotLabel,
                         sorryLabel,
                         willSuggestNextTimeLabel,
                         registerSpotButton,
                         howAboutTheseLabel)
    }

    private func setLayout() {
        noMatchingSpotLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24 + ScreenUtils.navViewHeight)
            $0.centerX.equalToSuperview()
        }

        sorryLabel.snp.makeConstraints {
            $0.top.equalTo(noMatchingSpotLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }

        willSuggestNextTimeLabel.snp.makeConstraints {
            $0.top.equalTo(sorryLabel.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
        }

        registerSpotButton.snp.makeConstraints {
            $0.top.equalTo(willSuggestNextTimeLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)
        }

        howAboutTheseLabel.snp.makeConstraints {
            $0.top.equalTo(sorryLabel.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
        }
    }

    private func setStyle() {
        backgroundColor = .clear

        noMatchingSpotLabel.setLabel(text: StringLiterals.SpotList.noMatchingSpot, style: .t2SB, alignment: .center)

        sorryLabel.setLabel(text: StringLiterals.SpotList.sorryForNotShowing, style: .b1R, color: .gray500)

        
        willSuggestNextTimeLabel.setLabel(text: StringLiterals.SpotList.willSuggestNextTime, style: .t4SB, alignment: .center)

        registerSpotButton.setAttributedTitle(text: StringLiterals.SpotList.registerSpot, style: .b1SB, color: .labelAction)

        howAboutTheseLabel.setLabel(text: StringLiterals.SpotList.howAboutTheseInstead, style: .t4SB)

        [willSuggestNextTimeLabel, registerSpotButton, howAboutTheseLabel].forEach { $0.isHidden = true }
    }

}


// MARK: - Internal Methods

extension NoMatchingSpotHeader {

    func setHeader(_ type: NoMatchingSpotType) {
        let hasSpot: Bool = type == .withSuggestion

        [willSuggestNextTimeLabel, registerSpotButton].forEach { $0.isHidden = hasSpot }
        howAboutTheseLabel.isHidden = !hasSpot
    }

}
