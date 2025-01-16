//
//  CustomAlert.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/16/25.
//

import UIKit
import SnapKit
import Then


final class CustomAlertView: BaseViewController {
    
    private let alertContainer = UIView() // Alert 컨테이너 추가
    private let messageLabel = UILabel()
    private let closeButton = UIButton()
    private let settingsButton = UIButton()
    
    var onClose: (() -> Void)?
    var onSettings: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setStyle() {
        view.do {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.6) // 배경 반투명 설정
        }
        
        alertContainer.do {
            $0.backgroundColor = .darkGray
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }
        
        messageLabel.do {
            $0.text = "위치를 확인할 수 없습니다.\n설정에서 위치접근 권한을 허용해주세요."
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 16, weight: .medium)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        closeButton.do {
            $0.setTitle("닫기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .darkGray
            $0.layer.cornerRadius = 8
            $0.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        }
        
        settingsButton.do {
            $0.setTitle("설정으로 가기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .orange
            $0.layer.cornerRadius = 8
            $0.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        }
    }
    
    override func setHierarchy() {
        view.addSubview(alertContainer) // Alert 컨테이너 추가
        alertContainer.addSubviews(messageLabel, closeButton, settingsButton)
    }
    
    override func setLayout() {
        // Alert 컨테이너 중앙 배치
        alertContainer.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(200)
        }
        
        // 내부 UI 요소 배치
        messageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(alertContainer.snp.centerX).offset(-8)
            $0.height.equalTo(44)
        }
        
        settingsButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.leading.equalTo(alertContainer.snp.centerX).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(44)
        }
    }
    
    // MARK: - Actions
    @objc private func closeTapped() {
        dismiss(animated: true) {
            self.onClose?()
        }
    }
    
    @objc private func settingsTapped() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

