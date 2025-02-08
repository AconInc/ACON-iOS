//
//  ProfileEditValidMessageView.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import UIKit

class ProfileEditValidMessageView: BaseView {
    
    // MARK: - UI Properties
    
    private let firstIcon = UIImageView()
    
    private let firstLine = UILabel()
    
    private let secondIcon = UIImageView()
    
    private let secondLine = UILabel()
    
    
    // MARK: - Life Cycle
    
    override func setHierarchy() {
        self.addSubviews(
            firstIcon,
            firstLine,
            secondIcon,
            secondLine
        )
    }
    
    override func setLayout() {
        firstIcon.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        firstLine.snp.makeConstraints {
            $0.leading.equalTo(firstIcon.snp.trailing).offset(4)
            $0.centerY.equalTo(firstIcon)
        }
        
        secondIcon.snp.makeConstraints {
            $0.top.equalTo(firstIcon.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        secondLine.snp.makeConstraints {
            $0.leading.equalTo(secondIcon.snp.trailing).offset(4)
            $0.centerY.equalTo(secondIcon)
        }
    }
    
    override func setStyle() {
        [firstIcon, secondIcon].forEach {
            $0.image = .icError20
        }
        
        [firstLine, secondLine].forEach {
            $0.setLabel(text: "test", style: .s2, color: .red1)
        }
    }
    
}
