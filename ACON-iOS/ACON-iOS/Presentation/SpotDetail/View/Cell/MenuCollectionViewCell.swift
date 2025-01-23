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
            $0.width.height.equalTo(ScreenUtils.heightRatio*78)
            $0.trailing.equalToSuperview()
        }
        
        menuNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*31)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(ScreenUtils.widthRatio*94)
        }
        
        menuPriceLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*31)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(ScreenUtils.widthRatio*94)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.backgroundColor = .clear
        menuImageView.do {
            $0.layer.cornerRadius = 6
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
    }
    
}

extension MenuCollectionViewCell {
    
    func dataBind(_ data: SpotMenuModel, _ indexRow: Int) {
        if let imageURL = data.imageURL {
            menuImageView.kf.setImage(with: URL(string: imageURL), options: [.transition(.none), .cacheOriginalImage])
        }
        menuNameLabel.setLabel(text: data.name,
                               style: .b2)
        if data.price == -1 {
            menuPriceLabel.setLabel(text: "변동",
                                   style: .s1)
        } else {
            menuPriceLabel.setLabel(text: data.price.formattedWithSeparator + "원",
                                   style: .s1)
        }
    }
    
}
