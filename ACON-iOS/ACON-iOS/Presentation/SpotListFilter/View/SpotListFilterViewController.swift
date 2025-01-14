//
//  SpotListFilterViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

class SpotListFilterViewController: BaseNavViewController {
    
    // MARK: - Properties
    
    let spotListFilterView = SpotListFilterView()
    let viewModel = SpotListFilterViewModel()
    
    
    // MARK: - LifeCycles
    
    override func loadView() {
        view = spotListFilterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
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
            print("updateView!")
        }
    }
    
}


// MARK: - UI Update

private extension SpotListFilterViewController {
    
    // TODO: restaurant
    
    func updateView(_ spotType: SpotType) {
        updateFeatureStack(spotType)
        
    }
    
    private func updateFeatureStack(_ spotType: SpotType) {
        let featureStack = spotListFilterView.spotFeatureStackView
        
        // clear stack
        featureStack.clearStackView()
        
        // add buttons
        for feature in SpotListFilterModel.RestaurantFeature.firstLine {
            let btn = FilterTagButton()
            
            btn.setAttributedTitle(text: feature.text, style: .b3)
            btn.addTarget(self,
                          action: #selector(didTapFilterTagButton),
                          for: .touchUpInside)
            
            featureStack.addTagButton(to: .first,
                                      button: btn)
        }
        
        for feature in SpotListFilterModel.RestaurantFeature.secondLine {
            let btn = FilterTagButton()
            btn.setAttributedTitle(text: feature.text, style: .b3)
            btn.addTarget(self,
                          action: #selector(didTapFilterTagButton),
                          for: .touchUpInside)
            
            featureStack.addTagButton(to: .second,
                                      button: btn)
        }
    }
    
}


// MARK: - @objc functions

private extension SpotListFilterViewController {
    
    @objc
    func didTapFilterTagButton(button: UIButton) {
        button.isSelected.toggle()
    }
    
}
