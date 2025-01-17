//
//  CustomAlertImageView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/16/25.
//

import UIKit

import SnapKit
import Then

final class CustomAlertImageView: BaseViewController {
    
    private let alertContainer = UIView()
    private let messageLabel = UILabel()
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let imageView = UIImageView()
    var onClose: (() -> Void)?
    var onSettings: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setStyle() {
        super.setStyle()
        
        view.do {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }
        
        imageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = .dotoriX
        }
        
        alertContainer.do {
            $0.backgroundColor = .gray8
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        titleLabel.do {
            $0.setLabel(
                text: AlertType.locationAccessFailImage.title,
                style: ACFont.h8,
                color: .acWhite,
                alignment: .center,
                numberOfLines: 2
            )
        }
        
        messageLabel.do {
            $0.setLabel(
                text: AlertType.locationAccessFailImage.content,
                style: ACFont.b2,
                color: .gray3,
                alignment: .center,
                numberOfLines: 2
            )
        }
        
        closeButton.do {
            $0.setAttributedTitle(
                text: "확인",
                style: ACFont.s2,
                color: .acWhite,
                for: .normal
            )
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .gray5
            $0.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        view.addSubview(alertContainer)
        alertContainer.addSubviews(messageLabel,
                                   titleLabel,
                                   closeButton,
                                   imageView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        alertContainer.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(ScreenUtils.width * 279 / 360)
            $0.height.equalTo(ScreenUtils.width * 279 / 360)
        }
        
        imageView.snp.makeConstraints{
            $0.top.equalTo(alertContainer.snp.top).inset(ScreenUtils.width * 24 / 360)
            $0.centerX.equalTo(alertContainer)
            $0.width.height.height.equalTo(ScreenUtils.width * 80 / 360)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(alertContainer)
            $0.horizontalEdges.equalTo(alertContainer).inset(ScreenUtils.width * 24 / 360)
            $0.top.equalTo(imageView.snp.bottom).offset(ScreenUtils.width * 16 / 360)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(ScreenUtils.width * 4 / 360)
            $0.horizontalEdges.equalTo(alertContainer).inset(ScreenUtils.width * 24 / 360)
            $0.centerX.equalTo(alertContainer)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(alertContainer).inset(ScreenUtils.width * 24 / 360)
            $0.width.equalTo(ScreenUtils.width * 231 / 360)
            $0.height.equalTo(ScreenUtils.width * 44 / 360)
            $0.bottom.equalTo(alertContainer).inset(ScreenUtils.width * 24 / 360)
        }
    }
    
}


extension CustomAlertImageView {
    
    @objc private func closeTapped() {
        dismiss(animated: true) {
            self.onClose?()
        }
    }
    
}
