//
//  SpotListFilterView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

class SpotListFilterView: GlassmorphismView {
    
    // MARK: - UI Properties
    
    private let pageTitleLabel = UILabel()
    
    let exitButton = UIButton()
    
    private let scrollView = UIScrollView()
    
    private let stackView = UIStackView()
    
    private let footerView = GlassmorphismView()
    
    private let resetButton = UIButton()
    
    private let conductButton = UIButton()
    
    
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
    
    private let walkingSectionStackView = UIStackView()
    
    private let walkingSectionTitleLabel = UILabel()
    
    let walkingSlider = CustomSlider(
        indicators: StringLiterals.SpotListFilter.walkingTimes,
        startIndex: 2)
    
    
    // [Price range]: 가격대 (restaurant, cafe)
    
    private let priceSectionStackView = UIStackView()
    
    private let priceSectionTitleLabel = UILabel()
    
    let restaurantPriceSlider = CustomSlider(
        indicators: StringLiterals.SpotListFilter.restaurantPrices,
        startIndex: 1)
    
    let cafePriceSlider = CustomSlider(
        indicators: StringLiterals.SpotListFilter.cafePrices,
        startIndex: 1)
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(
            pageTitleLabel,
            exitButton,
            scrollView,
            footerView
        )
        
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubviews(
            spotSectionStackView,
            companionSectionStackView,
            visitPurposeSectionStackView,
            walkingSectionStackView,
            priceSectionStackView
        )
        
        footerView.addSubviews(
            resetButton,
            conductButton
        )
        
        // [Spot section]
        
        spotSectionStackView.addArrangedSubviews(
            spotSectionTitleLabel,
            segmentedControl,
            spotTagStackView
        )
        
        spotTagStackView.addArrangedSubviews(
            firstLineSpotTagStackView,
            secondLineSpotTagStackView
        )
        
        
        // [Companion section]
        
        companionSectionStackView.addArrangedSubviews(
            companionSectionTitleLabel,
            companionTagStackView
        )
        
        
        // [Visit purpose section]
        
        visitPurposeSectionStackView
            .addArrangedSubviews(
                visitPurposeSectionTitleLabel,
                visitPurposeTagStackView
            )
        
        
        // [Walking time]
        
        walkingSectionStackView
            .addArrangedSubviews(
                walkingSectionTitleLabel,
                walkingSlider
            )
        
        
        // [Price range]
        
        priceSectionStackView
            .addArrangedSubviews(
                priceSectionTitleLabel,
                restaurantPriceSlider,
                cafePriceSlider
            )
    }
    
    override func setLayout() {
        super.setLayout()
        
        pageTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(33)
            $0.centerX.equalToSuperview()
        }
        
        exitButton.snp.makeConstraints {
            $0.centerY.equalTo(pageTitleLabel)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(pageTitleLabel.snp.bottom).offset(9)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(footerView.snp.top)
        }
        
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(ScreenUtils.heightRatio * 41)
            $0.width.equalTo(ScreenUtils.widthRatio * 320)
            $0.centerX.equalToSuperview()
        }
        
        footerView.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.heightRatio * 84)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        resetButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalTo(conductButton)
        }
        
        conductButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(ScreenUtils.widthRatio * 232)
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.height.equalTo(37)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setHandlerImageView()
        
        pageTitleLabel.setLabel(
            text: StringLiterals.SpotListFilter.pageTitle,
            style: .h8)
        
        exitButton.setImage(.icX, for: .normal)
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 32
        }
        
        setFooterUI()
        
        setSpotSectionUI()
        
        setCompanionSectionUI()
        
        setVisitPurposeSectionUI()
        
        setWalkingSectionUI()
        
        setPriceSectionUI()
    }
    
}


// MARK: - UI Settings

private extension SpotListFilterView {
    
    // MARK: - (Footer view)
    
    func setFooterUI() {
        resetButton.do {
            var config = UIButton.Configuration.plain()
            config.image = .icReset
            config.attributedTitle = AttributedString("재설정".ACStyle(.s2))
            $0.configuration = config
        }
        
        conductButton.do {
            var config = UIButton.Configuration.filled()
            config.attributedTitle = AttributedString("결과 보기".ACStyle(.h8))
            config.baseBackgroundColor = .gray5
            $0.configuration = config
        }
    }
    
    
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
    
    
    // MARK: - (Walking section)
    
    func setWalkingSectionUI() {
        walkingSectionStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
        }
        
        walkingSectionTitleLabel.setLabel(
            text: StringLiterals.SpotListFilter.walkingSection,
            style: .s2)
    }
    
    
    // MARK: - (Price section)
    
    func setPriceSectionUI() {
        priceSectionStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
        }
        
        priceSectionTitleLabel.setLabel(
            text: StringLiterals.SpotListFilter.priceSection,
            style: .s2)
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
    
    func resetAllTagSelection() {
        [firstLineSpotTagStackView,
         secondLineSpotTagStackView,
         companionTagStackView,
         visitPurposeTagStackView].forEach {
            $0.resetTagSelection()
        }
    }
    
    func resetSliderPosition(animated: Bool = true) {
        [walkingSlider,
         restaurantPriceSlider,
         cafePriceSlider].forEach {
            $0.resetThumbPosition(animated: animated)
        }
    }
    
}
