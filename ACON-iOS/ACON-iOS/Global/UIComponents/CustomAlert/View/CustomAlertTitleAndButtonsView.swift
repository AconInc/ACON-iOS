//
//  CustomAlertTitleAndButtonsView.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/19/25.
//

import UIKit

import SnapKit
import Then

final class CustomAlertTitleAndButtonsView: BaseView {
    
    private let alertContainer = UIView()
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
            $0.backgroundColor = .gray8
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }

        closeButton.do {
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray5.cgColor
        }
        
        settingsButton.do {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .gray5
        }
        
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        addSubview(alertContainer)
        alertContainer.addSubviews(titleLabel, closeButton, settingsButton)
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
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.trailing.equalTo(alertContainer.snp.centerX).offset(-4)
            $0.width.equalTo(ScreenUtils.widthRatio * 112)
            $0.height.equalTo(ScreenUtils.widthRatio * 44)
        }
        
        settingsButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(alertContainer.snp.centerX).offset(4)
            $0.width.equalTo(ScreenUtils.widthRatio * 112)
            $0.height.equalTo(ScreenUtils.widthRatio * 44)
            $0.bottom.equalTo(alertContainer.snp.bottom).inset(ScreenUtils.widthRatio * 24)
        }
    }
    
    func configure(title: String, leftButton: String, rightButton: String) {

        titleLabel.do {
            $0.setLabel(
                text: title,
                style: ACFont.h8,
                color: .acWhite,
                alignment: .center,
                numberOfLines: 2
            )
        }

        closeButton.setAttributedTitle(
            text: leftButton,
            style: ACFont.s2,
            color: .gray3,
            for: .normal
        )
        
        settingsButton.setAttributedTitle(
            text: rightButton,
            style: ACFont.s2,
            color: .acWhite,
            for: .normal
        )
    }
    
    func reConfigureTitle(_ title: String) {
        titleLabel.do {
            $0.setLabel(
                text: title,
                style: ACFont.h8,
                color: .acWhite,
                alignment: .center,
                numberOfLines: 2
            )
        }
    }
    
}
