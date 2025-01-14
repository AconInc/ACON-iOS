//
//  SpotListFilterView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

class SpotListFilterView: BaseView {
    
    // MARK: - UI Properties
    // 제목
    private let titleLabel = UILabel()
    
    // 방문 장소
    private let spotStackView = UIStackView()
    
    private let spotTitleLabel = UILabel()
    
    let spotFeatureStackView = SpotFilterTagButtonStackView()
    
    // 함께 하는 사람
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        // 방문 장소
        self.addSubviews(titleLabel,
                         spotStackView)
        
        spotStackView.addArrangedSubviews(spotTitleLabel,
                                          spotFeatureStackView)
        
        // 함께 하는 사람
        
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
        }
        
        spotStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(17)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    override func setStyle() {
        // 방문 장소
        spotStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
        }
        
    }
    
}
