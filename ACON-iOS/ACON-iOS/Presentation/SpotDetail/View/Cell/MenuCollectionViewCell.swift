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
            $0.trailing.equalToSuperview()
        }
        
        menuNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*31/780)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(ScreenUtils.width*94/360)
        }
        
        menuPriceLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*31/780)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(ScreenUtils.width*94/360)
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
        menuPriceLabel.setLabel(text: data.price.formattedWithSeparator + "원",
                               style: .s1)
    }
    
}
