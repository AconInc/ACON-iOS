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
    
    private let viewModel = SpotListViewModel()
    
    var completionHandler: ((SpotConditionModel) -> Void)?
    
    var spotType: SpotType = .restaurant
    
    var spotCondition: SpotConditionModel = SpotConditionModel(spotType: .restaurant, filterList: [], walkingTime: -1, priceRange: -1)
    
    var filterList: [SpotFilterListModel] = []
    
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTargets()
        updateView(spotType)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isBeingDismissed {
            completionHandler?(spotCondition)
        }
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
        self.spotType = index == 0 ? .restaurant : .cafe
        updateView(self.spotType)
      }
    
    
    @objc
    func didTapExitButton() {
        self.dismiss(animated: true)
    }
    
    @objc
    func didTapConductButton() {
        switch self.spotType {
        case .restaurant:
            let restaurantFilter = configureRestaurantFilter()
            let companionFilter = configureCompanionFilter()
            
            self.filterList.append(restaurantFilter)
            self.filterList.append(companionFilter)
            
        case .cafe:
            let cafeFilter = configureCafeFilter()
            let visitPurposeFilter = configureVisitPurposeFilter()
            
            self.filterList.append(cafeFilter)
            self.filterList.append(visitPurposeFilter)
        }
        
        self.spotCondition = SpotConditionModel(
            spotType: self.spotType,
            filterList: self.filterList,
            walkingTime: -1,
            priceRange: -1
        )
        // TODO: 도보 가능 거리, 가격대 필터링
        self.dismiss(animated: true)
    }
    
    @objc func didTapResetButton() {
        self.spotCondition = SpotConditionModel(
            spotType: self.spotType,
            filterList: [],
            walkingTime: -1,
            priceRange: -1
        )
        self.dismiss(animated: true)
    }
    
}


// MARK: - Spot Type에 따른 UI Update

private extension SpotListFilterViewController {
    
    func updateView(_ spotType: SpotType) {
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
    
}


// MARK: - Assisting method

extension SpotListFilterViewController {
    
    func configureRestaurantFilter() -> SpotFilterListModel {
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
            category: SpotType.FilterCategoryType.restaurantFeature.serverKey,
            optionList: restaurantFeatureOptionList
        )
        
        return restaurantFilterList
    }
    
    func configureCafeFilter() -> SpotFilterListModel {
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
                cafeFeatureOptionList.append(cafeFeatures[i + 5].serverKey)
            }
        }
        
        let cafeFilterList = SpotFilterListModel(
            category: SpotType.FilterCategoryType.cafeFeature.serverKey,
            optionList: cafeFeatureOptionList
        )
        
        return cafeFilterList
    }
    
    func configureCompanionFilter() -> SpotFilterListModel {
        let companionType = SpotType.CompanionType.allCases
        var companionOptionList: [String] = []
        
        for (i, button) in spotListFilterView.companionTagStackView.arrangedSubviews.enumerated() {
            let tagButton = button as? FilterTagButton ?? UIButton()
            if tagButton.isSelected {
                companionOptionList.append(companionType[i].serverKey)
            }
        }
        
        let companionFilterList = SpotFilterListModel(
            category: SpotType.FilterCategoryType.companion.serverKey,
            optionList: companionOptionList
        )
        
        return companionFilterList
    }
    
    func configureVisitPurposeFilter() -> SpotFilterListModel {
        let visitPurpose = SpotType.VisitPurposeType.allCases
        var visitPurposeOptionList: [String] = []
        
        for (i, button) in spotListFilterView.visitPurposeTagStackView.arrangedSubviews.enumerated() {
            let tagButton = button as? FilterTagButton ?? UIButton()
            if tagButton.isSelected {
                visitPurposeOptionList.append(visitPurpose[i].serverKey)
            }
        }
        
        let visitPurposeFilterList = SpotFilterListModel(
            category: SpotType.FilterCategoryType.visitPurpose.serverKey,
            optionList: visitPurposeOptionList
        )
        
        return visitPurposeFilterList
    }
    
}
