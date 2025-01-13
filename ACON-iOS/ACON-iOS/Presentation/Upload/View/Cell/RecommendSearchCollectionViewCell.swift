//
//  RecommendSearchCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import UIKit

import SnapKit
import Then

final class RecommendSearchCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Properties
    
    private let spotNameLabel: UILabel = UILabel()
    
    private let spotAddressLabel: UILabel = UILabel()
    
    private let spotTypeLabel: UILabel = UILabel()
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(spotNameLabel,
                         spotAddressLabel,
                         spotTypeLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        spotNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*7/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(20)
            $0.width.equalTo(ScreenUtils.width*250/360)
        }
        
        spotAddressLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*7/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(14)
            $0.width.equalTo(ScreenUtils.width*250/360)
        }
        
        spotTypeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.trailing.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(14)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.backgroundColor = .gray9
    }
    
}

extension RecommendSearchCollectionViewCell() {
    
    func bindData() {

    }
    
}
