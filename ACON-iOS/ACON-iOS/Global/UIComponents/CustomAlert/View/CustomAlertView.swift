//
//  CustomAlertView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/17/25.
//

import UIKit

import SnapKit
import Then

final class CustomAlertView: BaseView {
    
    private let alertContainer = UIView()
    private let messageLabel = UILabel()
    private let titleLabel = UILabel()
    let closeButton = UIButton()
    let settingsButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        alertContainer.do {
            $0.backgroundColor = .gray800
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }

        closeButton.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray500.cgColor
        }
        
        settingsButton.do {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .gray500
        }
        
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        addSubview(alertContainer)
        alertContainer.addSubviews(messageLabel, titleLabel, closeButton, settingsButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        alertContainer.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(ScreenUtils.widthRatio * 279)
            $0.height.greaterThanOrEqualTo(ScreenUtils.widthRatio * 279 * 0.5)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(alertContainer)
            $0.top.horizontalEdges.equalTo(alertContainer).inset(ScreenUtils.widthRatio * 24)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(alertContainer).inset(ScreenUtils.widthRatio * 24)
            $0.centerX.equalTo(alertContainer)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.trailing.equalTo(alertContainer.snp.centerX).offset(-4)
            $0.width.equalTo(ScreenUtils.widthRatio * 112)
            $0.height.equalTo(ScreenUtils.widthRatio * 44)
        }
        
        settingsButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.leading.equalTo(alertContainer.snp.centerX).offset(4)
            $0.width.equalTo(ScreenUtils.widthRatio * 112)
            $0.height.equalTo(ScreenUtils.widthRatio * 44)
            $0.bottom.equalTo(alertContainer.snp.bottom).inset(ScreenUtils.widthRatio * 24)
        }
    }
    
    func configure(title: String, message: String, leftButton: String, rightButton: String) {
        
        /* NOTE: 여기에 style 적용한 이유 -> 상단에서 적용후 text만 따로 넣으니 컬러 및 폰트 적용 x
        alertcustomiamgeview도 같은 이유
         */
                 
        titleLabel.do {
            $0.setLabel(
                text: title,
                style: ACFont.h8,
                color: .acWhite,
                alignment: .center,
                numberOfLines: 2
            )
        }
        
        messageLabel.do {
            $0.setLabel(
                text: message,
                style: ACFont.b2,
                color: .gray300,
                alignment: .center,
                numberOfLines: 2
            )
        }

        closeButton.setAttributedTitle(
            text: leftButton,
            style: ACFont.s2,
            color: .gray300,
            for: .normal
        )
        
        settingsButton.setAttributedTitle(
            text: rightButton,
            style: ACFont.s2,
            color: .acWhite,
            for: .normal
        )
    }
    
}
