//
//  StickyHeaderView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/17/25.
//

import UIKit

import SnapKit
import Then

class StickyHeaderView: BaseView {
    
    let menuLabel: UILabel = UILabel()
    let menuUnderLineView: UIView = UIView()
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(menuLabel, menuUnderLineView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        menuLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(2)
            $0.width.equalTo(63)
        }
        
        menuUnderLineView.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
            $0.height.equalTo(2)
            $0.width.equalTo(63)
        }
    }
    
    override func setStyle() {
        self.backgroundColor = .gray900
        self.alpha = 1
        
        menuLabel.do {
            $0.setLabel(text: StringLiterals.SpotDetail.menu,
                        style: .s2,
                        alignment: .center)
        }
        
        menuUnderLineView.do {
            $0.backgroundColor = .acWhite
        }
    }
    
}
