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
        
        titleLabel.do {
            $0.font = ACFont.s2.font
            $0.textColor = .acWhite
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.backgroundColor = .clear
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
            $0.width.equalTo(101)
            $0.height.equalTo(129)
        }
        
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(container)
            $0.height.equalTo(container.snp.width).multipliedBy(1.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.centerX.equalTo(container)
            $0.height.equalTo(20)
        }
        
        overlayContainer.snp.makeConstraints {
            $0.edges.equalTo(imageView)
        }
        
        overlayImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func checkConfigure(name: String, image: UIImage?, isSelected: Bool) {
        titleLabel.text = name
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
        titleLabel.text = name
        imageView.image = image ?? UIImage(systemName: "photo")
        overlayContainer.backgroundColor = .clear
        
        switch isSelected {
        case 1:
            overlayImageView.image = UIImage(named: "1")
            overlayContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayImageView.alpha = 1
        case 2:
            overlayImageView.image = UIImage(named: "2")
            overlayContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayImageView.alpha = 1
        case 3:
            overlayImageView.image = UIImage(named: "3")
            overlayContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayImageView.alpha = 1
        case 4:
            overlayImageView.image = UIImage(named: "4")
            overlayContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayImageView.alpha = 1
        default:
            overlayContainer.backgroundColor = .clear
            overlayImageView.image = nil
            overlayImageView.alpha = 0
        }
    }
}
