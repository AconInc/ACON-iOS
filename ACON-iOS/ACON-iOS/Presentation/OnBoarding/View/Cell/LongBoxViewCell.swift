//
//  FavoriteRankCollectionViewCell.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/16/25.
//

import UIKit

import SnapKit
import Then

final class LongBoxViewCell: BaseCollectionViewCell {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let overlayImageView = UIImageView()
    private let overlayContainer = UIView()
    private let container = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        super.setStyle()
        
        backgroundColor = .clear

        imageView.do {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
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
    
    override func setHierarchy() {
        super.setHierarchy()
        
        contentView.addSubview(container)
        container.addSubviews(
            imageView,
            titleLabel,
            overlayContainer
        )
        overlayContainer.addSubview(overlayImageView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.width.equalTo(154).priority(.low)
            $0.height.equalTo(296).priority(.low)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.centerX.equalTo(container)
            $0.height.equalTo(20).priority(.low)
        }
        
        overlayContainer.snp.makeConstraints {
            $0.edges.equalTo(imageView)
        }
        
        overlayImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func checkConfigure(name: String, image: UIImage?, isSelected: Bool) {
        titleLabel.setLabel(
                text: name,
                style: OldACFont.s2,
                color: .acWhite,
                alignment: .center,
                numberOfLines: 0
        )
        imageView.image = image ?? UIImage(systemName: "photo")
        
        if isSelected {
            overlayContainer.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            overlayImageView.image = .icCheck
            overlayImageView.layer.shadowColor = UIColor.black.cgColor
            overlayImageView.layer.shadowOpacity = 0.6
            overlayImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
            overlayImageView.layer.shadowRadius = 4
            overlayImageView.alpha = 1
        } else {
            overlayContainer.backgroundColor = .clear
            overlayImageView.image = nil
            overlayImageView.alpha = 0
        }
    }
}
