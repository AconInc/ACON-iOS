//
//  SpotListFilterView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

class SpotListFilterView: BaseView {
    
    // MARK: - Properties
    
    private let segmentItems = [StringLiterals.SpotListFilter.restaurant,
                                StringLiterals.SpotListFilter.cafe]
    
    
    // MARK: - UI Properties
    
    // [Spot section]: 방문 장소 (restaurant + cafe)
    
    private let spotSectionStackView = UIStackView()
    
    private let spotSectionTitleLabel = UILabel()

    lazy var segmentedControl = UISegmentedControl(items: segmentItems)
    
    private let segmentedControlBgView = UIView()
    
    let spotFeatureStackView = SpotFilterTagButtonStackView()
    
    
    // [Companion section]: 함께 하는 사람 (restaurant)
    
    let companionTypeStackView = SpotFilterTagButtonStackView()
    
    // TODO: 방문 목적, 도보 가능 거리, 가격대
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(spotSectionStackView)
        
        // [Spot section]
        
        spotSectionStackView.addArrangedSubviews(spotSectionTitleLabel,
                                                 segmentedControlBgView,
                                                 spotFeatureStackView)
        
        segmentedControlBgView.addSubview(segmentedControl)
        
        
        
    }
    
    override func setLayout() {
        super.setLayout()
        
        // [Spot section]
        
        spotSectionStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtils.heightRatio * 41)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio * 20)
        }
        
        segmentedControlBgView.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.heightRatio * 37)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(ScreenUtils.heightRatio * 3)
        }
        
        
        
        
    }
    
    override func setStyle() {
        super.setStyle()
        
        // [Spot section]
        
        setSpotSectionUI()
        
        
        
        
        // TODO: 추후 추가 예정
    }
    
}


// MARK: - UI Settings

private extension SpotListFilterView {
    
    // MARK: - (Spot section)
    
    func setSpotSectionUI() {
        spotSectionStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
        }
        
        spotSectionTitleLabel.do {
            $0.setLabel(text: StringLiterals.SpotListFilter.spotSection,
                        style: .s2)
            
        setSegmentControl()
        
        }
    }
    
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



// MARK: - UI Settings (Companion section)
