//
//  CustomLocationAlertView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/16/25.
//

import UIKit
import SnapKit

final class CustomLocationAlertView: BaseViewController {

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let confirmButton = UIButton()
    private let alertView = UIView()

    var onConfirm: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    override func setStyle() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        alertView.do {
            
            $0.backgroundColor = .darkGray
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }
        
        // 아이콘 설정
        iconImageView.do {
            $0.image = UIImage(named: "locationFailIcon") // 실패 아이콘 이미지 설정
            $0.contentMode = .scaleAspectFit
        }
        
        // 제목 설정
        titleLabel.do {
            $0.text = "위치 인식 실패"
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            $0.textAlignment = .center
        }
        
        // 메시지 설정
        messageLabel.do {
            $0.text = "현재 위치와 등록 장소가 오차범위 밖에 있습니다.\n좀 더 가까이 이동해보세요."
            $0.textColor = .lightGray
            $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        // 확인 버튼 설정
        confirmButton.do {
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .orange
            $0.layer.cornerRadius = 8
            $0.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        }
    }
    override func setHierarchy() {
        view.addSubview(alertView)
        alertView.addSubviews(iconImageView, titleLabel, messageLabel, confirmButton)
        
    }
    override func setLayout() {
        
        alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(260)
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 60, height: 60))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    @objc private func confirmTapped() {
        dismiss(animated: true) {
            self.onConfirm?()
        }
    }
}
