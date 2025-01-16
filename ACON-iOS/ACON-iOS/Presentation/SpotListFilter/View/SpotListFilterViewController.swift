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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        addTargets()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        contentView.addSubview(spotListFilterView)
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
            
            print("spotType: \(spotType)")
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
            for: .valueChanged)
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
        
        // NOTE: clear stack
        featureStack.clearStackView()
        
        // TODO: Type으로 바꾸기
//        switch spotType {
//        case .restaurant:
//            let arr = SpotType.RestaurantFeatureType.allCases
//            let arr1 = returnFirstArray(array: arr, firstLineCount: spotType.featureFirstLineCount)
//            let arr2 = returnSecondArray(array: arr, firstLineCount: spotType.featureFirstLineCount)
//            
//        case .cafe:
//            let arr = SpotType.CafeFeatureType.allCases
//            let arr1 = returnFirstArray(array: arr, firstLineCount: spotType.featureFirstLineCount)
//            let arr2 = returnSecondArray(array: arr, firstLineCount: spotType.featureFirstLineCount)
//        }
        
        // NOTE: add buttons
        switch spotType {
        case .restaurant:
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
                              action: #selector(didTapFilterTagButton(_:)),
                              for: .touchUpInside)
                
                featureStack.addTagButton(to: .second,
                                          button: btn)
            }
            
            
        case .cafe:
            for feature in SpotListFilterModel.CafeFeature.firstLine {
                let btn = FilterTagButton()
                
                btn.setAttributedTitle(text: feature.text, style: .b3)
                btn.addTarget(self,
                              action: #selector(didTapFilterTagButton),
                              for: .touchUpInside)
                
                featureStack.addTagButton(to: .first,
                                          button: btn)
            }
            
            for feature in SpotListFilterModel.CafeFeature.secondLine {
                let btn = FilterTagButton()
                btn.setAttributedTitle(text: feature.text, style: .b3)
                btn.addTarget(self,
                              action: #selector(didTapFilterTagButton(_:)),
                              for: .touchUpInside)
                
                featureStack.addTagButton(to: .second,
                                          button: btn)
            }
        }
        
        featureStack.addEmptyView() // 오른쪽 여백 추가
    }
    
}


// MARK: - @objc functions

private extension SpotListFilterViewController {
    
    @objc
    func didTapFilterTagButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc func didChangeSpot(segment: UISegmentedControl) {
        print("didChangeSpot")
        let index = segment.selectedSegmentIndex
        viewModel.spotType.value = index == 0 ? .restaurant : .cafe
      }
}


// MARK: - Assisting method

extension SpotListFilterViewController {
    
    func returnFirstArray<T>(array: T, firstLineCount: Int) -> T where T: RangeReplaceableCollection, T: RandomAccessCollection {
        return T(array.prefix(firstLineCount))
    }
    
    func returnSecondArray<T>(array: T, firstLineCount: Int) -> T where T: RangeReplaceableCollection, T: RandomAccessCollection {
        return T(array.dropFirst(firstLineCount))
    }
}
