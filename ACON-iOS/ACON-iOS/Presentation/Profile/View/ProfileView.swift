//
//  ProfileView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/17/25.
//

import UIKit

import Then
import SnapKit

final class ProfileView: BaseView {
    
    private let imageView = UIImageView()
    private let messageLabel = UILabel()
    
    override func setStyle() {
        super.setStyle()
        
        self.backgroundColor = .gray9
        
        imageView.do {
            $0.image = .construction
            $0.contentMode = .scaleAspectFit
        }
        
        messageLabel.do {
            $0.setLabel(text: "지금은 공사중이에요!",
                        style: .b2,
                        color: .gray4,
                        alignment: .center,
                        numberOfLines: 1)
        }
        
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(imageView,messageLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(ScreenUtils.width * 113 / 360)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(3)
            $0.centerX.equalTo(imageView)
        }
    }
    
}
