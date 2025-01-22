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
    
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        addTargets()
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


// MARK: - Binding ViewModel

private extension SpotListFilterViewController {
    
    func bindViewModel() {
        viewModel.spotType.value = .restaurant
        
        viewModel.spotType.bind { [weak self] spotType in
            guard let self = self,
                  let spotType = spotType
            else { return }
            
            updateView(spotType)
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
    }
    
}


// MARK: - @objc functions

private extension SpotListFilterViewController {
    
    @objc
    func didChangeSpot(segment: UISegmentedControl) {
        let index = segment.selectedSegmentIndex
        viewModel.spotType.value = index == 0 ? .restaurant : .cafe
      }
    
    
    @objc
    func didTapExitButton() {
        self.dismiss(animated: true)
    }
    
    @objc
    func didTapConductButton() {
        switch viewModel.spotType.value {
        case .restaurant:
            let restaurantFilter = configureRestaurantFilter()
            let companionFilter = configureCompanionFilter()
            
            viewModel.filterList.append(restaurantFilter)
            viewModel.filterList.append(companionFilter)
            
        case .cafe:
            let cafeFilter = configureCafeFilter()
            let visitPurposeFilter = configureVisitPurposeFilter()
            
            viewModel.filterList.append(cafeFilter)
            viewModel.filterList.append(visitPurposeFilter)
            
        case .none:
            print("Impossible Case")
        }
        
        // TODO: 도보 가능 거리, 가격대 필터링
        viewModel.postSpotList()
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
// TODO: 메소드 수정
extension SpotListFilterViewController {
//    
//    func returnFirstArray<T>(array: T, firstLineCount: Int) -> T where T: RangeReplaceableCollection, T: RandomAccessCollection {
//        return T(array.prefix(firstLineCount))
//    }
//    
//    func returnSecondArray<T>(array: T, firstLineCount: Int) -> T where T: RangeReplaceableCollection, T: RandomAccessCollection {
//        return T(array.dropFirst(firstLineCount))
//    }
//
    
    
    func configureRestaurantFilter() -> SpotFilterListModel {
        let restaurantFeatures = SpotType.RestaurantFeatureType.allCases
        var restaurantFeatureOptionList: [String] = []
        
        for (i, button) in spotListFilterView.firstLineSpotTagStackView.tagButtons.enumerated() {
            if button.isSelected {
                restaurantFeatureOptionList.append(restaurantFeatures[i].serverKey)
            }
        }
        
        for (i, button) in spotListFilterView.secondLineSpotTagStackView.tagButtons.enumerated() {
            if button.isSelected {
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
        
        for (i, button) in spotListFilterView.firstLineSpotTagStackView.tagButtons.enumerated() {
            if button.isSelected {
                cafeFeatureOptionList.append(cafeFeatures[i].serverKey)
            }
        }
        
        for (i, button) in spotListFilterView.secondLineSpotTagStackView.tagButtons.enumerated() {
            if button.isSelected {
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
        
        for (i, button) in spotListFilterView.companionTagStackView.tagButtons.enumerated() {
            if button.isSelected {
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
        let visitPurpose = SpotType.CompanionType.allCases
        var visitPurposeOptionList: [String] = []
        
        for (i, button) in spotListFilterView.companionTagStackView.tagButtons.enumerated() {
            if button.isSelected {
                visitPurposeOptionList.append(visitPurpose[i].serverKey)
            }
        }
        
        let visitPurposeFilterList = SpotFilterListModel(
            category: SpotType.FilterCategoryType.companion.serverKey,
            optionList: visitPurposeOptionList
        )
        
        return visitPurposeFilterList
    }
    
    
}
