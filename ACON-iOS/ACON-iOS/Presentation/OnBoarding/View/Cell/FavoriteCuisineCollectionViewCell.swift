//
//  FavoriteCuisineCollectionViewCell.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/15/25.
//

import UIKit

import SnapKit
import Then

final class FavoriteCuisineCollectionViewCell: BaseCollectionViewCell {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let overlayImageView = UIImageView()
    private let overlayContainer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func setStyle() {
        
        imageView.do {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        
        titleLabel.do {
            $0.font = ACFont.s2.font
            $0.textColor = .acWhite
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        overlayContainer.do {
            $0.layer.cornerRadius = 8
        }
        
        overlayImageView.do {
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.alpha = 0
        }
    }
    
    internal override func setHierarchy() {
        
        contentView.addSubviews(imageView,titleLabel,overlayContainer)
        overlayContainer.addSubview(overlayImageView)
    }
    
    internal override func setLayout() {
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        overlayContainer.snp.makeConstraints {
            $0.edges.equalTo(imageView)
        }
        
        overlayImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    func configure(name: String, image: UIImage?, isSelected: Int) {
        
        titleLabel.text = name
        imageView.image = image ?? UIImage(systemName: "photo")
        
        switch isSelected {
        case 1:
            overlayContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayImageView.image = UIImage(named: "1")
            overlayImageView.alpha = 1
        case 2:
            overlayContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayImageView.image = UIImage(named: "2")
            overlayImageView.alpha = 1
        case 3:
            overlayContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayImageView.image = UIImage(named: "3")
            overlayImageView.alpha = 1
        case 4:
            overlayContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayImageView.image = UIImage(named: "4")
            overlayImageView.alpha = 1
        default:
            overlayContainer.backgroundColor = .clear
            overlayImageView.image = nil
            overlayImageView.alpha = 0
        }
    }
}
