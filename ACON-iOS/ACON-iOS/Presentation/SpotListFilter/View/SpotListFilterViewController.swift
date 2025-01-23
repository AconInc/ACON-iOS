//
//  SpotListFilterViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

class SpotListFilterViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let spotListFilterView = SpotListFilterView()
    
    private let viewModel: SpotListViewModel
    
    var walkingTime: SpotType.WalkingDistanceType = .twentyFive
    
    var restaurantPrice: SpotType.RestaurantPriceType = .fiftyThousandAbove
    
    var cafePrice: SpotType.CafePriceType = .aboveTenThousand
    
    
    // MARK: - LifeCycles
    
    init(viewModel: SpotListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTargets()
        switchedSegment(viewModel.spotType.value)
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyConditions(
            spotType: viewModel.spotType.value ?? .restaurant,
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
    
    private func setDelegate() {
        spotListFilterView.walkingSlider.delegate = self
        spotListFilterView.restaurantPriceSlider.delegate = self
        spotListFilterView.cafePriceSlider.delegate = self
    }
}


// MARK: - Add Target

private extension SpotListFilterViewController {
    
    func addTargets() {
        spotListFilterView.segmentedControl.addTarget(
            self,
            action: #selector(didChangeSpot),
            for: .valueChanged
        )
        
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
    func didChangeSpot(segment: UISegmentedControl) {
        let index = segment.selectedSegmentIndex
        let spotType: SpotType = index == 0 ? .restaurant : .cafe
        viewModel.spotType.value = spotType
        switchedSegment(spotType)
      }
    
    
    @objc
    func didTapExitButton() {
        self.dismiss(animated: true)
    }
    
    @objc
    func didTapConductButton() {
        guard let spotType = viewModel.spotType.value else {
            viewModel.spotType.value = .restaurant
            return // TODO: 인덱스 오류 해결
        }
        
        switch spotType {
        case .restaurant:
            let restaurantFilter = extractRestaurantFilter()
            let companionFilter = extractCompanionFilter()
            
            viewModel.filterList.append(restaurantFilter)
            viewModel.filterList.append(companionFilter)
            
        case .cafe:
            let cafeFilter = extractCafeFilter()
            let visitPurposeFilter = extractVisitPurposeFilter()
            
            viewModel.filterList.append(cafeFilter)
            viewModel.filterList.append(visitPurposeFilter)
        }
        
        viewModel.walkingTime = self.walkingTime
        viewModel.restaurantPrice = self.restaurantPrice
        viewModel.cafePrice = self.cafePrice
        
        viewModel.postSpotList()
        self.dismiss(animated: true)
    }
    
    @objc func didTapResetButton() {
        self.viewModel.spotType.value = nil
        self.viewModel.filterList = []
        self.viewModel.spotCondition = SpotConditionModel(
            spotType: .restaurant,
            filterList: [],
            walkingTime: -1,
            priceRange: -1
        )
        viewModel.postSpotList()
        self.dismiss(animated: true)
    }
    
}


// MARK: - Spot Type에 따른 UI Update

private extension SpotListFilterViewController {
    
    func switchedSegment(_ spotType: SpotType?) {
        guard let spotType = spotType else { return }
        
        spotListFilterView.do {
            // NOTE: spot tag 바꾸기
            $0.switchSpotTagStack(spotType)
            
            // NOTE: companion tag는 restaurant일 때만 보임
            $0.hideCompanionSection(isHidden: spotType == .cafe)
            
            // NOTE: visit purpose tag는 cafe일 때만 보임
            $0.hideVisitPurposeSection(isHidden: spotType == .restaurant)
            
            $0.switchPriceSlider(spotType: spotType)
            
            $0.resetAllTagSelection()
            
            $0.resetSliderPosition(animated: false)
        }
    }
    
    func applyConditions(spotType: SpotType, filterLists: [SpotFilterListModel]) {
        // NOTE: 세그먼트 컨트롤 세팅
        spotListFilterView.segmentedControl.selectedSegmentIndex = spotType == .cafe ? 1 : 0
        switchedSegment(spotType)
        
        // NOTE: tag 세팅
        for filterList in filterLists {
            let category = filterList.category
            print("🥑applied filterList: \(filterList), 🥑spotType: \(spotType)")
            
            switch category {
            case .restaurantFeature, .cafeFeature:
                applySpotConditionToUI(
                    spotType: spotType,
                    optionList: filterList.optionList)

            case .companion:
                applyCompanionConditionToUI(optionList: filterList.optionList)
            case .visitPurpose:
                applyVisitPurposeConditionToUI(optionList: filterList.optionList)
            }
        }
        
        // NOTE: 슬라이더 세팅
        let walkingTimeIndex = SpotType.WalkingDistanceType.allCases.firstIndex(of: viewModel.walkingTime) ?? 2
        let restaurantPriceIndex = SpotType.RestaurantPriceType.allCases.firstIndex(of: viewModel.restaurantPrice) ?? 1
        let cafePriceIndex = SpotType.CafePriceType.allCases.firstIndex(of: viewModel.cafePrice) ?? 2
        
        print("🫙 뷰모델 슬라이더 인덱스: \(walkingTimeIndex), \(restaurantPriceIndex), \(cafePriceIndex)")
        spotListFilterView.walkingSlider.moveThumbPosition(to: walkingTimeIndex)
        spotListFilterView.restaurantPriceSlider.moveThumbPosition(to: restaurantPriceIndex)
        spotListFilterView.cafePriceSlider.moveThumbPosition(to: cafePriceIndex)
    }
    
}


// MARK: - Assisting method

extension SpotListFilterViewController {
    
    // MARK: - UI -> VM
    
    func extractRestaurantFilter() -> SpotFilterListModel {
        let restaurantFeatures = SpotType.RestaurantFeatureType.allCases
        var restaurantFeatureOptionList: [String] = []
        
        for (i, button) in spotListFilterView.firstLineSpotTagStackView.arrangedSubviews.enumerated() {
            let tagButton = button as? FilterTagButton ?? UIButton()
            if tagButton.isSelected {
                restaurantFeatureOptionList.append(restaurantFeatures[i].serverKey)
            }
        }
        
        for (i, button) in spotListFilterView.secondLineSpotTagStackView.arrangedSubviews.enumerated() {
            let tagButton = button as? FilterTagButton ?? UIButton()
            if tagButton.isSelected {
                restaurantFeatureOptionList.append(restaurantFeatures[i + 5].serverKey)
            }
        }
        
        let restaurantFilterList = SpotFilterListModel(
            category: SpotType.FilterCategoryType.restaurantFeature,
            optionList: restaurantFeatureOptionList
        )
        
        return restaurantFilterList
    }
    
    func extractCafeFilter() -> SpotFilterListModel {
        let cafeFeatures = SpotType.CafeFeatureType.allCases
        var cafeFeatureOptionList: [String] = []
        for (i, button) in spotListFilterView.firstLineSpotTagStackView.arrangedSubviews.enumerated() {
            let tagButton = button as? FilterTagButton ?? UIButton()
            if tagButton.isSelected {
                cafeFeatureOptionList.append(cafeFeatures[i].serverKey)
            }
        }
        
        for (i, button) in spotListFilterView.secondLineSpotTagStackView.arrangedSubviews.enumerated() {
            let tagButton = button as? FilterTagButton ?? UIButton()
            if tagButton.isSelected {
                cafeFeatureOptionList.append(cafeFeatures[i + 4].serverKey)
            }
        }
        
        let cafeFilterList = SpotFilterListModel(
            category: SpotType.FilterCategoryType.cafeFeature,
            optionList: cafeFeatureOptionList
        )
        
        return cafeFilterList
    }
    
    func extractCompanionFilter() -> SpotFilterListModel {
        let companionType = SpotType.CompanionType.allCases
        var companionOptionList: [String] = []
        
        for (i, button) in spotListFilterView.companionTagStackView.arrangedSubviews.enumerated() {
            let tagButton = button as? FilterTagButton ?? UIButton()
            if tagButton.isSelected {
                companionOptionList.append(companionType[i].serverKey)
            }
        }
        
        let companionFilterList = SpotFilterListModel(
            category: SpotType.FilterCategoryType.companion,
            optionList: companionOptionList
        )
        
        return companionFilterList
    }
    
    func extractVisitPurposeFilter() -> SpotFilterListModel {
        let visitPurpose = SpotType.VisitPurposeType.allCases
        var visitPurposeOptionList: [String] = []
        
        for (i, button) in spotListFilterView.visitPurposeTagStackView.arrangedSubviews.enumerated() {
            let tagButton = button as? FilterTagButton ?? UIButton()
            if tagButton.isSelected {
                visitPurposeOptionList.append(visitPurpose[i].serverKey)
            }
        }
        
        let visitPurposeFilterList = SpotFilterListModel(
            category: SpotType.FilterCategoryType.visitPurpose,
            optionList: visitPurposeOptionList
        )
        
        return visitPurposeFilterList
    }
    
    
    // MARK: - VM -> UI
    
    func applySpotConditionToUI(spotType: SpotType, optionList: [String]) {
        let tagKeys: [String] = {
            switch spotType {
            case .restaurant:
                return SpotType.RestaurantFeatureType.allCases.map { return $0.serverKey }
            case .cafe:
                return SpotType.CafeFeatureType.allCases.map { return $0.serverKey }
            }
        }()
        
        let firstLineKeys: [String] = Array(tagKeys[0..<spotType.firstLineCount])
        let secondLineKeys: [String] = Array(tagKeys[spotType.firstLineCount...])
        
        for (i, tagKey) in firstLineKeys.enumerated() {
            if optionList.contains(tagKey) {
                (spotListFilterView.firstLineSpotTagStackView.arrangedSubviews[i] as? FilterTagButton ?? UIButton()).isSelected = true
            }
        }
        
        for (i, tagKey) in secondLineKeys.enumerated() {
            if optionList.contains(tagKey) {
                (spotListFilterView.secondLineSpotTagStackView.arrangedSubviews[i] as? FilterTagButton ?? UIButton()).isSelected = true
            }
        }
    }
    
    func applyCompanionConditionToUI(optionList: [String]) {
        let tagKeys = SpotType.CompanionType.allCases.map { return $0.serverKey }
        
        for (i, tagKey) in tagKeys.enumerated() {
            if optionList.contains(tagKey) {
                (spotListFilterView.companionTagStackView.arrangedSubviews[i] as? FilterTagButton ?? UIButton()).isSelected = true
            }
        }
    }
    
    func applyVisitPurposeConditionToUI(optionList: [String]) {
        let tagKeys = SpotType.VisitPurposeType.allCases.map { return $0.serverKey }
        
        for (i, tagKey) in tagKeys.enumerated() {
            if optionList.contains(tagKey) {
                (spotListFilterView.visitPurposeTagStackView.arrangedSubviews[i] as? FilterTagButton ?? UIButton()).isSelected = true
            }
        }
    }
}


// MARK: - Slider Delegate

extension SpotListFilterViewController: SliderViewDelegate {
    func sliderView(_ sender: CustomSlider, changedValue value: Int) {
        
        // NOTE: Wallking distance
        if sender == spotListFilterView.walkingSlider {
            let walkingTime = SpotType.WalkingDistanceType.allCases
            self.walkingTime = walkingTime[value]
        }
        
        // NOTE: Restaurant price
        else if sender == spotListFilterView.restaurantPriceSlider {
            let priceRange = SpotType.RestaurantPriceType.allCases
            self.restaurantPrice = priceRange[value]
        }
        
        // NOTE: Cafe price
        else if sender == spotListFilterView.cafePriceSlider {
            let priceRange = SpotType.CafePriceType.allCases
            self.cafePrice = priceRange[value]
        }
    }
    
}
