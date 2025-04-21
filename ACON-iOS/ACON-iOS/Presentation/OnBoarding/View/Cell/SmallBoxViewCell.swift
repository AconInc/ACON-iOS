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
    private let overlayTitle = UIView()
    
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
        
        overlayTitle.do {
            $0.alpha = 0
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .clear
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
        titleLabel.addSubview(overlayTitle)
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
        
        overlayTitle.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        overlayContainer.snp.makeConstraints {
            $0.edges.equalTo(imageView)
        }
        
        overlayImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func checkConfigure(name: String, image: UIImage?, isSelected: Bool, isDimmed: Bool = false) {
        titleLabel.setLabel(
            text: name,
            style: ACFont.s2,
            color: .acWhite,
            alignment: .center,
            numberOfLines: 0
        )
        imageView.image = image ?? UIImage(systemName: "photo")
        
        if isSelected {
            // 선택된 상태: 화이트 딤 처리
            overlayContainer.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            overlayImageView.image = UIImage(named: "check")
            overlayImageView.layer.shadowColor = UIColor.black.cgColor
            overlayImageView.layer.shadowOpacity = 0.6
            overlayImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
            overlayImageView.layer.shadowRadius = 4
            overlayImageView.alpha = 1
            overlayTitle.backgroundColor = .clear
            overlayTitle.alpha = 0
          } else if isDimmed {
              overlayContainer.backgroundColor = UIColor.gray900.withAlphaComponent(0.9)
              overlayImageView.image = nil
              overlayImageView.alpha = 0
              overlayTitle.backgroundColor = UIColor.gray900.withAlphaComponent(0.7)
              overlayTitle.alpha = 1
          } else {
              // 기본 상태
              overlayContainer.backgroundColor = .clear
              overlayImageView.image = nil
              overlayImageView.alpha = 0
              overlayTitle.backgroundColor = .clear
              overlayTitle.alpha = 0
          }
        
    }
    
    func configure(name: String, image: UIImage?, isSelected: Int, isDimmed: Bool = false) {
        titleLabel.setLabel(
            text: name,
            style: ACFont.s2,
            color: .acWhite,
            alignment: .center,
            numberOfLines: 0
        )
        titleLabel.backgroundColor = .gray900
        imageView.image = image ?? UIImage(systemName: "photo")
        
        applyOverlaySettings(isSelected: isSelected, isDimmed: isDimmed)
    }
    
}

extension SmallBoxViewCell {
    
    private func applyOverlaySettings(isSelected: Int, isDimmed: Bool) {
        if isDimmed {
            overlayContainer.backgroundColor = UIColor.gray900.withAlphaComponent(0.9)
            overlayImageView.image = nil
            overlayImageView.alpha = 0
            overlayTitle.backgroundColor = UIColor.gray900.withAlphaComponent(0.6)
            overlayTitle.alpha = 1
        } else if (1...3).contains(isSelected) {
            overlayImageView.image = UIImage(named: "\(isSelected)")
            overlayImageView.layer.shadowColor = UIColor.black.cgColor
            overlayImageView.layer.shadowOpacity = 0.6
            overlayImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
            overlayImageView.layer.shadowRadius = 4
            overlayContainer.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            overlayImageView.alpha = 1
            overlayTitle.backgroundColor = .clear
            overlayTitle.alpha = 0
        } else {
            overlayContainer.backgroundColor = .clear 
            overlayImageView.image = nil
            overlayImageView.alpha = 0
            overlayTitle.backgroundColor = .clear
            overlayTitle.alpha = 0
        }
    }


}
