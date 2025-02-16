//
//  WithdrawalTableViewCell.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/17/25.
//

import UIKit

import SnapKit
import Then

final class WithdrawalCollectionViewCell: BaseCollectionViewCell{
        
        private let imageView = UIImageView()
        private let titleLabel = UILabel()
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
                $0.backgroundColor = .clear
                $0.clipsToBounds = true
                $0.contentMode = .scaleAspectFill
            }
            
            titleLabel.do {
                $0.font = ACFont.s1.font
                $0.textColor = .acWhite
                $0.textAlignment = .center
                $0.numberOfLines = 0
            }
            
        }
        
        override func setHierarchy() {
            super.setHierarchy()
            
            contentView.addSubview(container)
            container.addSubviews(imageView,titleLabel)
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
            
        }
        
    func checkConfigure(name: String, isSelected: Bool) {
            titleLabel.text = name
        if isSelected == true {
            imageView
        }

    }
        
    }

    
    
