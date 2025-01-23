//
//  SpotListCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/12/25.
//

import UIKit

import Kingfisher

class SpotListCollectionViewCell: BaseCollectionViewCell {
    
    // TODO: bgImage dim 처리
    
    // MARK: - UI Properties
    
    private let bgImage = UIImageView()
    private let dimImage = UIImageView()
    
    private let matchingRateView = UIView()
    private let matchingRateLabel = UILabel()
    
    private let stackView = UIStackView()
    
    private let titleStackView = UIStackView()
    private let typeLabel = UILabel()
    private let nameLabel = UILabel()
    
    private let timeInfoStackView = UIStackView()
    private let walkingIcon = UIImageView()
    private let walkingTimeLabel = UILabel()
    
    
    // MARK: - Life Cycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(bgImage,
                         dimImage,
                         matchingRateView,
                         stackView)
        
        matchingRateView.addSubview(matchingRateLabel)
        
        stackView.addArrangedSubviews(titleStackView,
                                      timeInfoStackView)
        
        titleStackView.addArrangedSubviews(typeLabel,
                                           nameLabel)
        
        timeInfoStackView.addArrangedSubviews(walkingIcon,
                                              walkingTimeLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        let horizontalSpace = ScreenUtils.widthRatio * 16
        let verticalSpace = ScreenUtils.heightRatio * 16
        
        bgImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dimImage.snp.makeConstraints {
            $0.edges.equalTo(bgImage)
        }
        
        matchingRateView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(horizontalSpace)
            $0.top.equalToSuperview().offset(verticalSpace)
            $0.width.equalTo(96)
            $0.height.equalTo(22)
        }
        
        matchingRateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(horizontalSpace)
            $0.bottom.equalToSuperview().inset(verticalSpace)
        }
        
        walkingIcon.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }
    
    override func setStyle() {
        backgroundColor = .clear
        
        bgImage.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 6
        }
        
        dimImage.do {
            $0.clipsToBounds = true
            $0.image = .dimGra2
            $0.layer.cornerRadius = 6
        }
        
        matchingRateView.do {
            $0.backgroundColor = .gray9
            $0.layer.cornerRadius = 2
        }
        
        matchingRateLabel.do {
            $0.setText(.b4, .acWhite)
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 4
        }
        
        titleStackView.do {
            $0.axis = .vertical
            $0.spacing = 0
        }
        
        timeInfoStackView.do {
            $0.spacing = 0
        }
        
        walkingIcon.do {
            $0.image = .icWalking24
            $0.contentMode = .scaleAspectFit
        }
    }
    
}


// MARK: - Binding

extension SpotListCollectionViewCell {
    
    func bind(spot: SpotModel, matchingRateBgColor: MatchingRateBgColorType) {
        bgImage.kf.setImage(
            with: URL(string: spot.imageURL),
            options: [.transition(.none), .cacheOriginalImage])
        
        changeMatchingRateBgColor(matchingRateBgColor)
        
        if let matchingRate = spot.matchingRate {
            let matchingRateHead = StringLiterals.SpotList.matchingRate
            let matchingRateStringSet = matchingRateHead + " " + String(matchingRate) + "%"
            matchingRateLabel.setLabel(text: matchingRateStringSet,
                                       style: .b4)
        }
        
        typeLabel.setLabel(text: spot.type.koreanText,
                           style: .b4)
        
        nameLabel.setLabel(text: spot.name,
                           style: .h7)
        
        walkingTimeLabel.setLabel(text: "\(String(spot.walkingTime))분",
                                  style: .b4,
                                  color: .gray3)
    }
    
}


// MARK: - UI Change Methods

extension SpotListCollectionViewCell {
    
    private func changeMatchingRateBgColor(_ matchingRateBgColor: MatchingRateBgColorType) {
        matchingRateView.backgroundColor = matchingRateBgColor.color
    }
    
}
