//
//  SpotListFilterView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

class SpotListFilterView: BaseView {
    
    // MARK: - UI Properties
    
    let spotTypeSegmentControl = UISegmentedControl()
    
    let spotFeatureStackView = SpotFilterTagButtonStackView()
    
    // TODO: 함께 하는 사람, 방문 목적, 도보 가능 거리, 가격대
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(spotTypeSegmentControl,
                         spotFeatureStackView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        spotFeatureStackView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(17)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        // TODO: 추후 추가 예정
    }
    
}
