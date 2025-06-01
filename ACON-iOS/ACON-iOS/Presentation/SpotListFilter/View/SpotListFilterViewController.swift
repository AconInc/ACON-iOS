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
        
        bindViewModel()
        addTargets()
        switchedSegment(viewModel.spotType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyConditions(
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


// MARK: - Bindings

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
        viewModel.filterList = []
        
        // NOTE: 앰플리튜드
        switch viewModel.spotType {
        case .restaurant:
            let restaurantFilter = extractRestaurantFilter()
            
            viewModel.filterList.append(restaurantFilter)
            
            // NOTE: 앰플리튜드
            AmplitudeManager.shared.trackEventWithProperties(
                AmplitudeLiterals.EventName.filter,
                properties: [
                    "choose_filter_restaurant?" : true,
                    "filter_visit_click_food" : restaurantFilter.optionList,
                    "complete_filter_restaurant?" : !restaurantFilter.optionList.isEmpty
                ]
            )
            
        case .cafe:
            let cafeFilter = extractCafeFilter()
            
            viewModel.filterList.append(cafeFilter)
            
            // NOTE: 앰플리튜드
            AmplitudeManager.shared.trackEventWithProperties(
                AmplitudeLiterals.EventName.filter,
                properties: [
                    "choose_filter_cafe?" : true,
                    "filter_visit_click_cafe" : cafeFilter.optionList,
                    "complete_filter_cafe?" : !cafeFilter.optionList.isEmpty
                ]
            )
        }
        
        viewModel.requestLocation()
        spotListFilterView.conductButton.startLoadingAnimation()
    }
    
    @objc func didTapResetButton() {
        viewModel.resetConditions()
        viewModel.requestLocation()
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
            $0.resetAllTagSelection()
        }
    }
    
    func applyConditions(spotType: SpotType, filterLists: [SpotFilterModel]) {
        // NOTE: 세그먼트 컨트롤 세팅
        switchedSegment(spotType)
        
        // NOTE: tag 세팅
        for filterList in filterLists {
            let category = filterList.category
            
            switch category {
            case .restaurantFeature, .cafeFeature:
                applySpotConditionToUI(
                    spotType: spotType,
                    optionList: filterList.optionList)
            case .openingHours: return // TODO: 수정
            case .price: return // TODO: 수정
            }
        }
    }
    
}


// MARK: - Helper

private extension SpotListFilterViewController {
    
    // MARK: - UI -> VM
    
    func extractRestaurantFilter() -> SpotFilterModel {
        let restaurantFeatures = SpotFilterType.RestaurantOptionType.allCases
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
        
        let restaurantFilterList = SpotFilterModel(
            category: SpotFilterType.restaurantFeature,
            optionList: restaurantFeatureOptionList
        )
        
        return restaurantFilterList
    }
    
    func extractCafeFilter() -> SpotFilterModel {
        let cafeFeatures = SpotFilterType.CafeOptionType.allCases
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
        
        let cafeFilterList = SpotFilterModel(
            category: SpotFilterType.cafeFeature,
            optionList: cafeFeatureOptionList
        )
        
        return cafeFilterList
    }
    
    
    // MARK: - VM -> UI
    
    func applySpotConditionToUI(spotType: SpotType, optionList: [String]) {
        let tagKeys: [String] = {
            switch spotType {
            case .restaurant:
                return SpotFilterType.RestaurantOptionType.allCases.map { return $0.serverKey }
            case .cafe:
                return SpotFilterType.CafeOptionType.allCases.map { return $0.serverKey }
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

}
