//
//  SearchEmptyView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/24/25.
//

import UIKit

import Then
import SnapKit

class SearchEmptyView: BaseView {
    
    // MARK: - UI Components
    
    private let emptyLabel: UILabel = UILabel()
    
    private let addPlaceTitleLabel: UILabel = UILabel()
    
    private let addPlaceDescriptionLabel: UILabel = UILabel()
    
    let addPlaceButton: UIButton = UIButton()
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(emptyLabel,
                         addPlaceTitleLabel,
                         addPlaceDescriptionLabel,
                         addPlaceButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20*ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
        }
        
        addPlaceTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100*ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
        }
        
        addPlaceDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(124*ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
        }
        
        addPlaceButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(156*ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)
            $0.width.equalTo(137)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.backgroundColor = .clear
        
        emptyLabel.do {
            $0.setLabel(text: StringLiterals.Upload.noMatchingSpots, style: .b1SB)
        }
        
        addPlaceTitleLabel.do {
            $0.setLabel(text: StringLiterals.Upload.addPlaceTitle, style: .b1SB)
        }
        
        addPlaceDescriptionLabel.do {
            $0.setLabel(text: StringLiterals.Upload.addPlaceDescriptuon,
                        style: .b1R,
                        color: .gray500)
        }
        
        addPlaceButton.do {
            $0.setAttributedTitle(text: StringLiterals.Upload.addPlaceButton,
                                  style: .b1SB,
                                  color: .labelAction)
        }
    }
    
}
