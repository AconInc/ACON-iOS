//
//  SpotListCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/12/25.
//

import UIKit

class SpotListCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Properties
    
    private let bgImage = UIImageView()
    
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
        
        bgImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        matchingRateView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(16)
            $0.width.equalTo(96)
            $0.height.equalTo(22)
        }
        
        matchingRateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(16)
        }
        
        walkingIcon.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }
    
    override func setStyle() {
        backgroundColor = .clear
        
        bgImage.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 6
            $0.clipsToBounds = true
        }
        
        matchingRateView.do {
            $0.backgroundColor = .gray9
            $0.layer.contents = 2
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
            $0.axis = .horizontal
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
    
    func bind(spot: Spot, matchingRateBgColor: MatchingRateBgColor) {
        bgImage.image = spot.image
        
        changeMatchingRateBgColor(matchingRateBgColor)
        
        matchingRateLabel.setLabel(text: "취향 일치율 \(String(spot.matchingRate))%",
                                   style: .b4)
        
        typeLabel.setLabel(text: spot.type,
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
    
    private func changeMatchingRateBgColor(_ matchingRateBgColor: MatchingRateBgColor) {
        matchingRateView.backgroundColor = matchingRateBgColor.color
    }
    
}
