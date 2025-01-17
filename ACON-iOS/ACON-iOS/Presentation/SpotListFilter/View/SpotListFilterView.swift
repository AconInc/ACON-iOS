//
//  SpotListFilterView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

class SpotListFilterView: BaseView {
    
    // MARK: - Properties
    
    
    
    // MARK: - UI Properties
    
    private let stackView = UIStackView()
    
    private let emptyView = PriorityLowEmptyView()
    
    
    // [Spot section]: 방문 장소 (restaurant, cafe)
    
    private let spotSectionStackView = UIStackView()
    
    private let spotSectionTitleLabel = UILabel()

    lazy var segmentedControl = CustomSegmentedControl()
    
    private let spotTagStackView = UIStackView()
    
    let firstLineSpotTagStackView = SpotFilterTagStackView()
    
    let secondLineSpotTagStackView = SpotFilterTagStackView()
    
    
    // [Companion section]: 함께 하는 사람 (restaurant)
    
    private let companionSectionStackView = UIStackView()
    
    private let companionSectionTitleLabel = UILabel()
    
    let companionTagStackView = SpotFilterTagStackView()
    
    
    // [Visit purpose]: 방문 목적 (cafe)
    
    private let visitPurposeSectionStackView = UIStackView()
    
    private let visitPurposeSectionTitleLabel = UILabel()
    
    let visitPurposeTagStackView = SpotFilterTagStackView()
    
    
    // [Walking time]: 도보 가능 거리 (restaurant, cafe)
    
    let walkingSlider = CustomSlider(
        indicators: StringLiterals.SpotListFilter.walkingTimes,
        startIndex: 2)
    
    
    // [Price range]: 가격대 (restaurant, cafe)
    
    let restaurantPriceSlider = CustomSlider(
        indicators: StringLiterals.SpotListFilter.restaurantPrices,
        startIndex: 1)
    
    let cafePriceSlider = CustomSlider(
        indicators: StringLiterals.SpotListFilter.cafePrices,
        startIndex: 1)
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(stackView)
        
        stackView.addArrangedSubviews(spotSectionStackView,
                                      companionSectionStackView,
                                      visitPurposeSectionStackView,
                                      walkingSlider,
                                      restaurantPriceSlider,
                                      cafePriceSlider,
                                      emptyView)
        
        // [Spot section]
        
        spotSectionStackView.addArrangedSubviews(spotSectionTitleLabel,
                                                 segmentedControl,
                                                 spotTagStackView)
        
        spotTagStackView.addArrangedSubviews(firstLineSpotTagStackView,
                                             secondLineSpotTagStackView)
        
        
        // [Companion section]
        
        companionSectionStackView.addArrangedSubviews(companionSectionTitleLabel,
                                                      companionTagStackView)
        
        
        // [Visit purpose section]
        
        visitPurposeSectionStackView.addArrangedSubviews(visitPurposeSectionTitleLabel,
                                                         visitPurposeTagStackView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtils.heightRatio * 41)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio * 20)
            $0.bottom.equalToSuperview()
        }
        
        segmentedControl.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.heightRatio * 37)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 32
        }
        
        
        // [Spot section]
        
        setSpotSectionUI()
        
        setCompanionSectionUI()
        
        setVisitPurposeSectionUI()
        
        // TODO: 추후 추가 예정
    }
    
}


// MARK: - UI Settings

private extension SpotListFilterView {
    
    // MARK: - (Spot section)
    
    func setSpotSectionUI() {
        spotSectionStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
        }
        
        spotSectionTitleLabel.do {
            $0.setLabel(text: StringLiterals.SpotListFilter.spotSection,
                        style: .s2)
        }
        
        spotTagStackView.do {
            $0.alignment = .leading
            $0.axis = .vertical
            $0.spacing = 5
        }
    }
    
    
    // MARK: - (Companion section)
    
    func setCompanionSectionUI() {
        companionSectionStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
        }
        
        companionSectionTitleLabel.setLabel(
            text: StringLiterals.SpotListFilter.companionSection,
            style: .s2)
        
        let tags: [String] = SpotType.CompanionType.allCases.map { return $0.text }
        companionTagStackView.addTagButtons(titles: tags)
    }
    
    
    // MARK: - (Visit purpose section)
    
    func setVisitPurposeSectionUI() {
        visitPurposeSectionStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
        }
        
        visitPurposeSectionTitleLabel.setLabel(
            text: StringLiterals.SpotListFilter.visitPurposeSection,
            style: .s2)
        
        let tags: [String] = SpotType.VisitPurposeType.allCases.map { return $0.text }
        visitPurposeTagStackView.addTagButtons(titles: tags)
    }
    
}


// MARK: - Internal Methods (Update UI)

extension SpotListFilterView {
    
    func switchSpotTagStack(_ spotType: SpotType) {
        
        // TODO: Model 대신 Type으로 바꾸기
        
        switch spotType {
        case .restaurant:
            let tagTexts: [String] = SpotType.RestaurantFeatureType.allCases.map { return $0.text }
            let firstLine: [String] = Array(tagTexts[0..<5])
            let secondLine: [String] = Array(tagTexts[5..<7])
            
            firstLineSpotTagStackView.switchTagButtons(titles: firstLine)
            secondLineSpotTagStackView.switchTagButtons(titles: secondLine)
            
        case .cafe:
            let tagTexts: [String] = SpotType.CafeFeatureType.allCases.map { return $0.text }
            let firstLine: [String] = Array(tagTexts[0..<4])
            let secondLine: [String] = [tagTexts[4]]
            
            firstLineSpotTagStackView.switchTagButtons(titles: firstLine)
            secondLineSpotTagStackView.switchTagButtons(titles: secondLine)
        }
    }
    
    func hideCompanionSection(isHidden: Bool) {
        companionSectionStackView.isHidden = isHidden
    }
    
    func hideVisitPurposeSection(isHidden: Bool) {
        visitPurposeSectionStackView.isHidden = isHidden
    }
    
    func switchPriceSlider(spotType: SpotType) {
        switch spotType {
        case .restaurant:
            restaurantPriceSlider.isHidden = false
            cafePriceSlider.isHidden = true
            
        case .cafe:
            restaurantPriceSlider.isHidden = true
            cafePriceSlider.isHidden = false
        }
    }
    
}
