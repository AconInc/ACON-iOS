//
//  DislikeCollectionViewCell.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/15/25.
//

import UIKit

import SnapKit
import Then

final class BigBoxViewCell: BaseCollectionViewCell {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let overlayImageView = UIImageView()
    private let overlayContainer = UIView()
    private let container = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        super.setStyle()
        
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
    
    override func setHierarchy() {
        super.setHierarchy()
        
        contentView.addSubview(container)
        container.addSubviews(imageView,
                              titleLabel,
                              overlayContainer)
        overlayContainer.addSubview(overlayImageView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(154).priority(.low)
        }
        
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(container.snp.width).multipliedBy(1.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(2)
            $0.centerX.equalTo(container)
            $0.height.equalTo(35).priority(.low)
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
        overlayImageView.layer.shadowColor = UIColor.black.cgColor
        overlayImageView.layer.shadowOpacity = 0.6
        overlayImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        overlayImageView.layer.shadowRadius = 4
        
        applyOverlaySettings(isSelected: isSelected)
    }
    
}

extension BigBoxViewCell {
    
    private func applyOverlaySettings(isSelected: Int) {
        guard (1...4).contains(isSelected) else {
            overlayContainer.backgroundColor = .clear
            overlayImageView.image = nil
            overlayImageView.alpha = 0
            return
        }
        
        overlayImageView.image = UIImage(named: "\(isSelected)")
        overlayContainer.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        overlayImageView.alpha = 1
    }
    
}
