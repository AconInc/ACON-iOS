//
//  test.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/16/25.
//

import UIKit

import SnapKit
import Then

final class SmallBoxViewCell: BaseCollectionViewCell {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let overlayImageView = UIImageView()
    private let overlayContainer = UIView()
    private let container = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        super.setStyle()
                
        container.do {
            $0.backgroundColor = .clear
        }
        
        imageView.do {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }

        overlayContainer.do {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .clear
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
            $0.width.equalTo(101).priority(.low)
            $0.height.equalTo(129).priority(.low)
        }
        
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(container)
            $0.height.equalTo(container.snp.width).multipliedBy(1.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8).priority(.low)
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
                style: ACFont.s2,
                color: .acWhite,
                alignment: .center,
                numberOfLines: 0
        )
        imageView.image = image ?? UIImage(systemName: "photo")
        
        if isSelected {
            overlayContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayImageView.image = UIImage(named: "check")
            overlayImageView.alpha = 1
        } else {
            overlayContainer.backgroundColor = .clear
            overlayImageView.image = nil
            overlayImageView.alpha = 0
        }
    }
    
    func configure(name: String, image: UIImage?, isSelected: Int) {
        titleLabel.setLabel(
                text: name,
                style: ACFont.s2,
                color: .acWhite,
                alignment: .center,
                numberOfLines: 0
        )
        imageView.image = image ?? UIImage(systemName: "photo")
        
        applyOverlaySettings(isSelected: isSelected)
    }
    
}

extension SmallBoxViewCell {
    
    private func applyOverlaySettings(isSelected: Int) {
        guard (1...4).contains(isSelected) else {
            overlayContainer.backgroundColor = .clear
            overlayImageView.image = nil
            overlayImageView.alpha = 0
            return
        }
        
        overlayImageView.image = UIImage(named: "\(isSelected)")
        overlayContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayImageView.alpha = 1
    }
    
}
