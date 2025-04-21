//
//  CustomAlertImageView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/17/25.
//

import UIKit

import SnapKit
import Then

final class CustomAlertImageView: BaseView {
    
    private let alertContainer = UIView()
    private let messageLabel = UILabel()
    private let titleLabel = UILabel()
    let closeButton = UIButton()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        imageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = .icError2
        }
        
        alertContainer.do {
            $0.backgroundColor = .gray800
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        closeButton.do {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .gray500
        }
        
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        addSubview(alertContainer)
        alertContainer.addSubviews(imageView,
                                   titleLabel,
                                   messageLabel,
                                   closeButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        alertContainer.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(ScreenUtils.widthRatio * 279)
            $0.height.equalTo(ScreenUtils.widthRatio * 279)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(alertContainer.snp.top).inset(ScreenUtils.widthRatio * 24)
            $0.centerX.equalTo(alertContainer)
            $0.width.height.equalTo(ScreenUtils.widthRatio * 80)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(alertContainer)
            $0.horizontalEdges.equalTo(alertContainer).inset(ScreenUtils.widthRatio * 24)
            $0.top.equalTo(imageView.snp.bottom).offset(ScreenUtils.widthRatio * 16)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(ScreenUtils.widthRatio * 4)
            $0.horizontalEdges.equalTo(alertContainer).inset(ScreenUtils.widthRatio * 24)
            $0.centerX.equalTo(alertContainer)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(alertContainer).inset(ScreenUtils.widthRatio * 24)
            $0.height.equalTo(ScreenUtils.widthRatio * 44)
            $0.bottom.equalTo(alertContainer).inset(ScreenUtils.widthRatio * 24)
        }
    }
    
    func configure(title: String, message: String, buttonText: String) {
        
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
        
        closeButton.do {
            $0.setAttributedTitle(
                text: buttonText,
                style: ACFont.s2,
                color: .acWhite,
                for: .normal
            )
        }
        
        closeButton.do {
            $0.setAttributedTitle(
                text: buttonText,
                style: ACFont.s2,
                color: .acWhite,
                for: .normal
            )
        }
        closeButton.layoutIfNeeded()
        
    }
}
