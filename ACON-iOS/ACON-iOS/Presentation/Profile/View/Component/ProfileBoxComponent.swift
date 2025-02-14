//
//  ProfileBoxComponent.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/7/25.
//

import UIKit

class ProfileBoxComponent: BaseView {
    
    // MARK: - UI Components
    
    private let titleStackView = UIStackView()
    
    private let iconImageView = UIImageView()
    
    private let titleLabel = UILabel()
    
    private var contentView = UIView()
    
    private var secondaryContentView = UIView()
    
    
    // MARK: - LifeCycles
    
    override func setHierarchy() {
        self.addSubviews(
            titleStackView,
            contentView,
            secondaryContentView
        )
        
        titleStackView.addArrangedSubviews(
            iconImageView,
            titleLabel
        )
    }
    
    override func setLayout() {
        titleStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        contentView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleStackView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        secondaryContentView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
    
    override func setStyle() {
        self.do {
            $0.backgroundColor = .gray8
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 6
        }
        
        titleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
        }
    }
    
}


// MARK: - Internal Methods

extension ProfileBoxComponent {
    
    func setStyle(title: String, icon: UIImage) {
        titleLabel.attributedText = title.ACStyle(.s2, .gray2)
        
        iconImageView.do {
            $0.image = icon
        }
    }
    
    func setContentView(to contentView: UIView) {
        self.contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        self.contentView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setSecondaryContentView(to contentView: UIView) {
        self.secondaryContentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        self.secondaryContentView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func switchContentView(toSecondary: Bool) {
        contentView.isHidden = toSecondary
        secondaryContentView.isHidden = !toSecondary
    }
    
}
