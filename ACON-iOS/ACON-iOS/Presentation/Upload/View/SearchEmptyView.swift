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
    
    private let descriptionLabel: UILabel = UILabel()
    
    
    // MARK: - UI Setting Methods
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(emptyLabel,
                         descriptionLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20*ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60*ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.backgroundColor = .clear
        
        emptyLabel.do {
            $0.setLabel(text: StringLiterals.Upload.noMatchingSpots, style: .b1SB)
        }
        
        descriptionLabel.do {
            $0.setLabel(text: StringLiterals.Upload.checkAgain, style: .b1R)
        }
    }
    
}


// MARK: - Internal Methods

extension SearchEmptyView {

    func makeAddSpotButton(target: Any, action: Selector) {
        let addSpotButton = UIButton()

        self.addSubview(addSpotButton)

        addSpotButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
        }

        addSpotButton.do {
            $0.setAttributedTitle(text: StringLiterals.Upload.addPlaceButton,
                                  style: .b1SB,
                                  color: .labelAction)
        }

        addSpotButton.addTarget(target, action: action, for: .touchUpInside)
    }
 
}
