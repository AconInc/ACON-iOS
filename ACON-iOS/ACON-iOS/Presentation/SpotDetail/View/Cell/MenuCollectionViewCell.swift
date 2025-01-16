//
//  MenuCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/16/25.
//

import UIKit

import SnapKit
import Then

final class MenuCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Properties
    
    private let menuImageView: UIImageView = UIImageView()
    
    private let menuNameLabel: UILabel = UILabel()
    
    private let menuPriceLabel: UILabel = UILabel()
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(menuImageView,
                         menuNameLabel,
                         menuPriceLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        menuImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(ScreenUtils.height*78/780)
            $0.leading.equalToSuperview()
        }
        
        menuNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*31/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*94/360)
            $0.trailing.equalToSuperview().inset(ScreenUtils.width*4/360)
        }
        
        menuPriceLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*31/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*94/360)
            $0.trailing.equalToSuperview().inset(ScreenUtils.width*4/360)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.backgroundColor = .clear
        menuImageView.do {
            $0.image = .imgStoreDetailMenulist
            $0.contentMode = .scaleAspectFill
        }
    }
    
}

extension MenuCollectionViewCell {
    
    func dataBind(_ menuInfoData: SpotMenuInfo, _ indexRow: Int) {
        // TODO: imageView kf
        menuNameLabel.setLabel(text: menuInfoData.name,
                               style: .b2)
        // TODO: 가격 쉼표 넣기
        menuPriceLabel.setLabel(text: String(menuInfoData.price) + "원",
                               style: .s1)
    }
    
}
