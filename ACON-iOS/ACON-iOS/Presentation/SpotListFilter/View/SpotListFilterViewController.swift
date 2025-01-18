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


// MARK: - Spot Type에 따른 UI Update

private extension SpotListFilterViewController {
    
    // TODO: restaurant
    
    func updateView(_ spotType: SpotType) {
        
        // TODO: 세그먼트 바뀔 때 버튼 선택 전부 해제되는지 기획 확인
        
        spotListFilterView.do {
            // NOTE: spot tag 바꾸기
            $0.switchSpotTagStack(spotType)
            
            // NOTE: companion tag는 restaurant일 때만 보임
            $0.hideCompanionSection(isHidden: spotType == .cafe)
            
            // NOTE: visit purpose tag는 cafe일 때만 보임
            $0.hideVisitPurposeSection(isHidden: spotType == .restaurant)
            
            $0.switchPriceSlider(spotType: spotType)
        }
    }
}


// MARK: - @objc functions

private extension SpotListFilterViewController {
    
    @objc func didChangeSpot(segment: UISegmentedControl) {
        let index = segment.selectedSegmentIndex
        viewModel.spotType.value = index == 0 ? .restaurant : .cafe
      }
    
}


// MARK: - Assisting method
// TODO: 메소드 수정
//extension SpotListFilterViewController {
//    
//    func returnFirstArray<T>(array: T, firstLineCount: Int) -> T where T: RangeReplaceableCollection, T: RandomAccessCollection {
//        return T(array.prefix(firstLineCount))
//    }
//    
//    func returnSecondArray<T>(array: T, firstLineCount: Int) -> T where T: RangeReplaceableCollection, T: RandomAccessCollection {
//        return T(array.dropFirst(firstLineCount))
//    }
//
//}
