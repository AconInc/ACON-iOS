//
//  SpotListFilterViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

class SpotListFilterViewController: BaseViewController {

    // MARK: - Properties

    private let spotListFilterView: SpotListFilterView

    private let viewModel: SpotListViewModel

    private var taggedFilterButtons: Set<FilterTagButton> = [] {
        didSet {
            let hasTaggedFilters = !taggedFilterButtons.isEmpty
            spotListFilterView.enableFooterButtons(hasTaggedFilters)
        }
    }


    // MARK: - LifeCycles

    init(viewModel: SpotListViewModel) {
        self.viewModel = viewModel
        self.spotListFilterView = SpotListFilterView(spotType: viewModel.spotType)
        
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        addTargets()
        setupFilterButtonCallbacks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyFiltersToUI(
            spotType: viewModel.spotType,
            filterLists: viewModel.filterList
        )
    }

    override func setHierarchy() {
        super.setHierarchy()
        
        view.addSubview(spotListFilterView)
    }

    override func setLayout() {
        super.setLayout()
        
        spotListFilterView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}


// MARK: - Bind VM

private extension SpotListFilterViewController {

    func bindViewModel() {
        viewModel.onFinishRefreshingSpotList.bind { [weak self] onFinish in
            guard let onFinish = onFinish else { return }
            
            if onFinish {
                self?.spotListFilterView.conductButton.endLoadingAnimation()
                self?.dismiss(animated: true)
            }
            
            self?.viewModel.onFinishRefreshingSpotList.value = nil
        }
    }

}


// MARK: - Add Target

private extension SpotListFilterViewController {

    func addTargets() {
        spotListFilterView.exitButton.addTarget(
            self,
            action: #selector(didTapExitButton),
            for: .touchUpInside
        )

        spotListFilterView.conductButton.addTarget(
            self,
            action: #selector(didTapConductButton),
            for: .touchUpInside
        )

        spotListFilterView.resetButton.addTarget(
            self,
            action: #selector(didTapResetButton),
            for: .touchUpInside
        )
    }

}


// MARK: - @objc functions

private extension SpotListFilterViewController {

    @objc
    func didTapExitButton() {
        self.dismiss(animated: true)
    }

    @objc
    func didTapConductButton() {
        var filterList: [SpotFilterModel] = []

        if let spotFilter: SpotFilterModel = viewModel.spotType == .restaurant ? extractRestaurantOptions() : extractCafeOptions() {
            filterList.append(spotFilter)
        }

        if let openingHoursFilter: SpotFilterModel = extractOpeningHours(spotType: viewModel.spotType) {
            filterList.append(openingHoursFilter)
        }

        if let priceFilter: SpotFilterModel = extractPrice(spotType: .restaurant) {
            filterList.append(priceFilter)
        }

        viewModel.filterList = filterList

        viewModel.updateLocationAndPostSpotList()
        spotListFilterView.conductButton.startLoadingAnimation()
    }

    @objc func didTapResetButton() {
        viewModel.resetConditions()
        viewModel.updateLocationAndPostSpotList()
        self.dismiss(animated: true)
    }

}


// MARK: - 필터 추출 및 적용 메소드

private extension SpotListFilterViewController {

    // MARK: - 추출 (UI -> VM)

    func extractRestaurantOptions() -> SpotFilterModel? {
        let firstLineCnt = SpotType.restaurant.firstLineCount
        let secondLineCnt = SpotType.restaurant.secondLineCount

        let firstLineOptions = extractSpotOptionkeys(
            spotType: .restaurant,
            tagButtons: spotListFilterView.firstLineSpotTagStackView.tags,
            previousLineCount: 0
        )
        let secondLineOptions = extractSpotOptionkeys(
            spotType: .restaurant,
            tagButtons: spotListFilterView.secondLineSpotTagStackView.tags,
            previousLineCount: firstLineCnt
        )
        let thirdLineOptions = extractSpotOptionkeys(
            spotType: .restaurant,
            tagButtons: spotListFilterView.thirdLineSpotTagStackView.tags,
            previousLineCount: firstLineCnt + secondLineCnt
        )

        let options = firstLineOptions + secondLineOptions + thirdLineOptions

        if options.isEmpty {
            return nil
        } else {
            return SpotFilterModel(
                category: SpotFilterType.restaurantFeature,
                optionList: firstLineOptions + secondLineOptions + thirdLineOptions
            )
        }
    }

    func extractCafeOptions() -> SpotFilterModel {
        let firstLineOptions = extractSpotOptionkeys(
            spotType: .cafe,
            tagButtons: spotListFilterView.firstLineSpotTagStackView.tags,
            previousLineCount: 0
        )

        return SpotFilterModel(
            category: SpotFilterType.cafeFeature,
            optionList: firstLineOptions
        )
    }

    func extractOpeningHours(spotType: SpotType) -> SpotFilterModel? {
        if spotListFilterView.openingHoursButton.isTagged {
            return SpotFilterModel(
                category: .openingHours,
                optionList: spotType == .restaurant
                ? [SpotFilterType.OpeningHoursOptionType.overMidnight.serverKey]
                : [SpotFilterType.OpeningHoursOptionType.overTenPM.serverKey]
            )
        }
        return nil
    }

    func extractPrice(spotType: SpotType) -> SpotFilterModel? {
        if spotType == .restaurant,
           spotListFilterView.goodPriceButton.isTagged {
            return SpotFilterModel(
                category: .price,
                optionList: [SpotFilterType.PriceOptionType.goodPrice.serverKey]
            )
        } else {
            return nil
        }
    }
    
    func extractSpotOptionkeys(spotType: SpotType,
                               tagButtons: [FilterTagButton],
                               previousLineCount: Int) -> [String] {
        let allKeys: [String] = spotType == .restaurant
        ? SpotFilterType.RestaurantOptionType.allCases.map { $0.serverKey }
        : SpotFilterType.CafeOptionType.allCases.map { $0.serverKey }

        var taggedKeys: [String] = []
        for (i, button) in tagButtons.enumerated() {
            if button.isTagged {
                taggedKeys.append(allKeys[i + previousLineCount])
            }
        }

        return taggedKeys
    }


    // MARK: - 적용 (VM -> UI)

    func applyFiltersToUI(spotType: SpotType, filterLists: [SpotFilterModel]) {
        for filterList in filterLists {
            switch filterList.category {
            case .restaurantFeature, .cafeFeature:
                applySpotOptionsToUI(spotType: spotType, optionList: filterList.optionList)
            case .openingHours:
                applyOpeningHoursOptionsToUI(isTagged: !filterList.optionList.isEmpty)
            case .price:
                applyPriceOptionToUI(isTagged: !filterList.optionList.isEmpty)
            }
        }
    }

    func applySpotOptionsToUI(spotType: SpotType, optionList: [String]) {
        let optionList: Set<String> = Set(optionList)

        switch spotType {
        case .restaurant:
            let tagKeys: [String] = SpotFilterType.RestaurantOptionType.allCases.map { return $0.serverKey }
            let firstLineKeys: [String] = Array(tagKeys[0..<spotType.firstLineCount])
            let secondLineKeys: [String] = Array(tagKeys[spotType.firstLineCount..<spotType.firstLineCount + spotType.secondLineCount])
            let thirdLineKeys: [String] = Array(tagKeys[(spotType.firstLineCount + spotType.secondLineCount)...])
            
            for (i, tagKey) in firstLineKeys.enumerated() {
                if optionList.contains(tagKey) {
                    spotListFilterView.firstLineSpotTagStackView.tags[i].isTagged = true
                }
            }

            for (i, tagKey) in secondLineKeys.enumerated() {
                if optionList.contains(tagKey) {
                    spotListFilterView.secondLineSpotTagStackView.tags[i].isTagged = true
                }
            }

            for (i, tagKey) in thirdLineKeys.enumerated() {
                if optionList.contains(tagKey) {
                    spotListFilterView.thirdLineSpotTagStackView.tags[i].isTagged = true
                }
            }

        case .cafe:
            let tagKeys: [String] = SpotFilterType.CafeOptionType.allCases.map { return $0.serverKey }

            let firstLineKeys: [String] = Array(tagKeys[0..<spotType.firstLineCount])

            for (i, tagKey) in firstLineKeys.enumerated() {
                if optionList.contains(tagKey) {
                    spotListFilterView.firstLineSpotTagStackView.tags[i].isTagged = true
                }
            }
        }
    }

    func applyOpeningHoursOptionsToUI(isTagged: Bool) {
        spotListFilterView.openingHoursButton.isTagged = isTagged
    }

    func applyPriceOptionToUI(isTagged: Bool) {
        spotListFilterView.goodPriceButton.isTagged = isTagged
    }

}


// MARK: - FilterTagButton call back 설정

private extension SpotListFilterViewController {

    private func setupFilterButtonCallbacks() {
        let allFilterButtons: [FilterTagButton] = spotListFilterView.firstLineSpotTagStackView.tags +
        spotListFilterView.secondLineSpotTagStackView.tags +
        spotListFilterView.thirdLineSpotTagStackView.tags +
        [spotListFilterView.openingHoursButton, spotListFilterView.goodPriceButton]
        
        allFilterButtons.forEach { button in
            button.onStateChanged = { [weak self] isTagged in
                self?.handleFilterButtonStateChange(button, isTagged)
            }
        }
    }

    private func handleFilterButtonStateChange(_ button: FilterTagButton, _ isTagged: Bool) {
        if isTagged {
            taggedFilterButtons.insert(button)
        } else {
            taggedFilterButtons.remove(button)
        }
    }

}
