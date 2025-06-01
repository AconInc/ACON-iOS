//
//  SpotListFilterView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

class SpotListFilterView: GlassmorphismView {

    // MARK: - Data

    let spotType: SpotType


    // MARK: - UI Properties

    private let pageTitleLabel = UILabel()
    
    let exitButton = UIButton()
    
    private let scrollView = UIScrollView()
    
    private let stackView = UIStackView()
    
    let resetButton = UIButton()
    
    let conductButton = LoadingAnimatedButton()
    
    
    // [Spot section]: 방문 장소 (restaurant, cafe)
    
    private let spotFeatureSectionStackView = UIStackView()
    
    private let spotSectionTitleLabel = UILabel()
    
    private let spotTagStackView = UIStackView()
    
    let firstLineSpotTagStackView = SpotFilterTagStackView()
    
    let secondLineSpotTagStackView = SpotFilterTagStackView()
    
    let thirdLineSpotTagStackView = SpotFilterTagStackView()
    
    
    // [Opening hours]: 운영 시간 (restaurant, cafe)
    
    private let openingHoursSectionView = UIView()
    
    private let openingHoursSectionTitleLabel = UILabel()
    
    private let openingHoursButton = FilterTagButton()
    
    
    // [Price range]: 가격대 (restaurant, cafe)
    
    private let priceSectionView = UIView()
    
    private let priceSectionTitleLabel = UILabel()
    
    private let goodPriceButton = FilterTagButton()
    
    
    // MARK: - Size
    
    private let horizontalEdge: CGFloat = 16
    private let sectionSpacing: CGFloat = 40
    private let innerSectionSpacing: CGFloat = 12
    
    
    // MARK: - Lifecycle
    
    init(spotType: SpotType) {
        self.spotType = spotType

        super.init(.bottomSheetGlass)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(
            pageTitleLabel,
            exitButton,
            scrollView,
            resetButton,
            conductButton
        )
        
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubviews(
            spotFeatureSectionStackView,
            openingHoursSectionView,
            priceSectionView
        )
        
        
        // [Spot section]
        
        spotFeatureSectionStackView.addArrangedSubviews(
            spotSectionTitleLabel,
            spotTagStackView
        )
        
        switch spotType {
        case .restaurant:
            spotTagStackView.addArrangedSubviews(
                firstLineSpotTagStackView,
                secondLineSpotTagStackView,
                thirdLineSpotTagStackView
            )
        case .cafe:
            spotTagStackView.addArrangedSubview(firstLineSpotTagStackView)
        }
        
        
        // [Operating hours section]
        openingHoursSectionView.addSubviews(
            openingHoursSectionTitleLabel,
            openingHoursButton
        )
        
        
        // [Price section]
        
        priceSectionView.addSubviews(
            priceSectionTitleLabel,
            goodPriceButton
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
            $0.trailing.equalToSuperview().offset(-horizontalEdge)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(pageTitleLabel.snp.bottom).offset(9)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(conductButton.snp.top)
        }
        
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(ScreenUtils.heightRatio * 41)
            $0.horizontalEdges.equalToSuperview().inset(horizontalEdge)
            $0.centerX.equalToSuperview()
        }
        
        openingHoursSectionTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        openingHoursButton.snp.makeConstraints {
            $0.top.equalTo(openingHoursSectionTitleLabel.snp.bottom).offset(innerSectionSpacing)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        
        priceSectionTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        goodPriceButton.snp.makeConstraints {
            $0.top.equalTo(priceSectionTitleLabel.snp.bottom).offset(innerSectionSpacing)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        resetButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(horizontalEdge)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(44)
            $0.width.equalTo(120 * ScreenUtils.widthRatio)
        }
        
        conductButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-horizontalEdge)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(44)
            $0.width.equalTo(200 * ScreenUtils.widthRatio)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setHandlerImageView()
        
        pageTitleLabel.setLabel(
            text: StringLiterals.SpotListFilter.pageTitle,
            style: .t3SB)
        
        exitButton.setImage(.icDismiss, for: .normal)
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = sectionSpacing
        }
        
        setFooterUI()
        setSpotFeatureSectionUI()
        setOpeningHoursSectionUI()
        setPriceSectionUI()
    }
}


// MARK: - UI Settings

private extension SpotListFilterView {
    
    // MARK: - (Footer view)
    
    func setFooterUI() {
        resetButton.do {
            var config = UIButton.Configuration.bordered()
            config.baseBackgroundColor = .clear
            config.cornerStyle = .capsule
            config.background.strokeWidth = 1
            $0.configuration = config

            // NOTE: 상태 변경에 따라 UI 업데이트
            $0.configurationUpdateHandler = { button in
                switch button.state {
                case .disabled:
                    button.configuration?.attributedTitle = AttributedString(StringLiterals.SpotListFilter.reset.attributedString(.b1SB, .gray300))
                    button.configuration?.background.strokeColor = .gray500 // TODO: Disabled glass로 변경
                default:
                    button.configuration?.attributedTitle = AttributedString(StringLiterals.SpotListFilter.reset.attributedString(.b1SB, .acWhite))
                    button.configuration?.background.strokeColor = .gray400 // TODO: Disabled glass로 변경
                }
            }
        }
        
        conductButton.do {
            var config = UIButton.Configuration.filled()
            config.cornerStyle = .capsule
            $0.configuration = config

            // NOTE: 상태 변경에 따라 UI 업데이트
            $0.configurationUpdateHandler = { button in
                switch button.state {
                case .disabled:
                    button.configuration?.attributedTitle = AttributedString(StringLiterals.SpotListFilter.showResults.attributedString(.b1SB, .gray300))
                    button.configuration?.baseBackgroundColor = .gray600 // TODO: glass로 변경
                default:
                    button.configuration?.attributedTitle = AttributedString(StringLiterals.SpotListFilter.showResults.attributedString(.b1SB, .acWhite))
                    button.configuration?.baseBackgroundColor = .gray400 // TODO: glass로 변경
                }
            }
        }
    }


    // MARK: - (Spot feature section)

    func setSpotFeatureSectionUI() {
        spotFeatureSectionStackView.do {
            $0.axis = .vertical
            $0.spacing = innerSectionSpacing
        }

        spotSectionTitleLabel.do {
            $0.setLabel(text: StringLiterals.SpotListFilter.kind,
                        style: .t5SB)
        }

        spotTagStackView.do {
            $0.alignment = .leading
            $0.axis = .vertical
            $0.spacing = 5
        }

        switch spotType {
        case .restaurant:
            let options: [String] = SpotFilterType.RestaurantOptionType.allCases.map { return $0.text }
            let firstLine: [String] = Array(options[0..<spotType.firstLineCount])
            let secondLine: [String] = Array(options[spotType.firstLineCount..<spotType.secondLineCount])
            let thirdLine: [String] = Array(options[spotType.secondLineCount...])

            firstLineSpotTagStackView.addTagButtons(titles: firstLine)
            secondLineSpotTagStackView.addTagButtons(titles: secondLine)
            thirdLineSpotTagStackView.addTagButtons(titles: thirdLine)

        case .cafe:
            let options: [String] = SpotFilterType.CafeOptionType.allCases.map { return $0.text }
            firstLineSpotTagStackView.addTagButtons(titles: options)
        }
    }


    // MARK: - (Operating hours section)
    
    func setOpeningHoursSectionUI() {
        openingHoursSectionTitleLabel.setLabel(text: StringLiterals.SpotListFilter.openingHours, style: .t5SB)
        
        let openingHoursOption: SpotFilterType.OpeningHoursOptionType = spotType == .restaurant ? .overMidnight : .overTenPM

        openingHoursButton.updateButtonTitle(openingHoursOption.text)
    }


    // MARK: - (Price section)

    func setPriceSectionUI() {
        switch spotType {
        case .restaurant:
            priceSectionTitleLabel.setLabel(
                text: StringLiterals.SpotListFilter.priceSection,
                style: .t5SB)

            goodPriceButton.updateButtonTitle(SpotFilterType.PriceOptionType.goodPrice.text)
        case .cafe:
            priceSectionView.isHidden = true
        }
    }

}


// MARK: - Internal Methods (Update UI)

extension SpotListFilterView {

    func resetAllTagSelection() {
        [openingHoursButton, goodPriceButton].forEach { $0.isSelected = false }
        [firstLineSpotTagStackView,
         secondLineSpotTagStackView,
         thirdLineSpotTagStackView].forEach {
            $0.resetTagSelection()
        }
    }

    func enableFooterButtons(_ isEnabled: Bool) {
        [resetButton, conductButton].forEach { $0.isEnabled = isEnabled }
    }

}
