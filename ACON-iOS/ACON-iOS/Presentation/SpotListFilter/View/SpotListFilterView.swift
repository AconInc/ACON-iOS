//
//  SpotListFilterView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

class SpotListFilterView: BaseView {
    
    // MARK: - UI Properties
    
    private let segmentItems = [StringLiterals.SpotListFilter.restaurant,
                                StringLiterals.SpotListFilter.cafe]
    
    lazy var segmentedControl = UISegmentedControl(items: segmentItems)
    
    private let segmentedControlBgView = UIView()
    
    let spotFeatureStackView = SpotFilterTagButtonStackView()
    
    // TODO: 함께 하는 사람, 방문 목적, 도보 가능 거리, 가격대
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(segmentedControlBgView,
                         spotFeatureStackView)
        
        segmentedControlBgView.addSubview(segmentedControl)
    }
    
    override func setLayout() {
        super.setLayout()
        
        segmentedControlBgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtils.heightRatio * 17)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.heightRatio * 20)
            $0.height.equalTo(ScreenUtils.heightRatio * 37)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(ScreenUtils.heightRatio * 3)
        }
        
        spotFeatureStackView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(ScreenUtils.heightRatio * 12)
            $0.horizontalEdges.equalTo(segmentedControl)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        setSegmentControl()
        
        
        // TODO: 추후 추가 예정
    }
    
}


// MARK: - UI Settings

private extension SpotListFilterView {
    
    func setSegmentControl() {
        segmentedControlBgView.do {
//            $0.backgroundColor = .gray8
            $0.layer.cornerRadius = ScreenUtils.heightRatio * 6
        }
        
        // TODO: 배경 없애기 커스텀
        segmentedControl.do {
            $0.selectedSegmentIndex = 0
            $0.selectedSegmentTintColor = .acWhite
            $0.backgroundColor = .gray8
            $0.setTitleTextAttributes(String.ACStyle(.s2, .gray5), for: .normal)
            $0.setTitleTextAttributes(String.ACStyle(.s2, .gray9), for: .selected)
        }
    }
    
}
