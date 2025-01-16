//
//  skdfnkasnfd.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/17/25.
//

import UIKit
import SwiftUI

import SnapKit
import Then

final class CustomAlertView: BaseViewController {
    
    private let alertContainer = UIView()
    private let messageLabel = UILabel()
    private let titleLabel = UILabel()
    private let imageView = UIImageView() // 이미지가 필요한 경우를 위해 추가
    private let buttonStackView = UIStackView()
    
    var onClose: (() -> Void)?
    var onSettings: (() -> Void)?
    var alertType: AlertType? // AlertType 저장
    
    // MARK: - Initializer
    init(type: AlertType) {
        super.init(nibName: nil, bundle: nil)
        self.alertType = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAlert()
    }
    
    override func setStyle() {
        super.setStyle()
        
        view.do {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }
        
        alertContainer.do {
            $0.backgroundColor = .gray8
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        titleLabel.do {
            $0.textColor = .acWhite
            $0.font = ACFont.h8.font
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
        
        messageLabel.do {
            $0.textColor = .gray3
            $0.font = ACFont.b2.font
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
        
        imageView.do {
            $0.contentMode = .scaleAspectFit
            $0.isHidden = true // 기본적으로 숨김
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 12
        }
    }
    
    override func setHierarchy() {
        view.addSubview(alertContainer)
        alertContainer.addSubviews(imageView, titleLabel, messageLabel, buttonStackView)
    }
    
    override func setLayout() {
        alertContainer.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(ScreenUtils.width * 279 / 360)
            $0.height.greaterThanOrEqualTo(ScreenUtils.width * 279 / 360 * 0.5)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10).priority(.low)
            $0.top.equalToSuperview().offset(20).priority(.high) // 이미지 없을 때
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // MARK: - Configure Alert
    private func configureAlert() {
        guard let type = alertType else { return }
        
        titleLabel.text = type.title
        messageLabel.text = type.content
        
        if type.hasImage {
            imageView.isHidden = false
            imageView.image = UIImage(named: "exampleImage") // 실제 이미지 이름 사용
        }
        
        // 버튼 추가
        buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // 이전 버튼 제거
        for (index, buttonTitle) in type.buttons.enumerated() {
            let button = UIButton(type: .system)
            button.setAttributedTitle(
                text: buttonTitle,
                style: ACFont.s2,
                color: index == 0 ? .gray3 : .acWhite, // 첫 번째 버튼: 회색, 나머지: 흰색
                for: .normal
            )
            button.layer.cornerRadius = 8
            button.backgroundColor = index == 0 ? .clear : .gray5
            button.layer.borderWidth = index == 0 ? 1 : 0
            button.layer.borderColor = index == 0 ? UIColor.gray5.cgColor : nil
            
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Actions
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let type = alertType else { return }
        
        switch (type, sender.tag) {
        case (.locationAccessDenied, 1), (.locationAccessDeniedOneButton, _):
            type.navigationAction?() // 설정으로 이동
        case (.stoppedWriting, 0), (.stoppedPreferenceAnalysis, 0):
            dismiss(animated: true, completion: onClose) // 닫기 동작
        default:
            dismiss(animated: true, completion: onSettings) // 계속하기 or 확인 동작
        }
    }
}
