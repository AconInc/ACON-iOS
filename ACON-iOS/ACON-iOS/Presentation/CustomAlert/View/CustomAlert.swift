//
//  CustomAlert.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/16/25.


import UIKit
import SwiftUI

import SnapKit
import Then

final class CustomAlertView: BaseViewController {
    
    private let alertContainer = UIView()
    private let messageLabel = UILabel()
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let settingsButton = UIButton()
    
    var onClose: (() -> Void)?
    var onSettings: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setStyle() {
        
        view.do {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }
        
        alertContainer.do {
            $0.backgroundColor = .gray8
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
//        titleLabel.do {
//            $0.setLabel(
//                text: "",
//                style: ACFont.h8,
//                color: .acWhite,
//                alignment: .center,
//                numberOfLines: 2
//            )
//        }
        titleLabel.do {
            $0.text = ""
            $0.font = ACFont.h8.font
            $0.textColor = .acWhite
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }

        messageLabel.do {
            $0.setLabel(
                text: "",
                style: ACFont.b2,
                color: .gray3,
                alignment: .center,
                numberOfLines: 2
            )
        }
        
        // UIButton 스타일 적용
        closeButton.do {
            $0.setAttributedTitle(
                text: "",
                style: ACFont.s2,
                color: .gray3,
                for: .normal
            )
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray5.cgColor
            $0.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        }
        
        settingsButton.do {
            $0.setAttributedTitle(
                text: "",
                style: ACFont.s2,
                color: .acWhite,
                for: .normal
            )
            $0.layer.cornerRadius = 8 // 네 꼭짓점 모두 둥글게
            $0.backgroundColor = .gray5
            $0.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        }
    }
    
    override func setHierarchy() {
        view.addSubview(alertContainer) // Alert 컨테이너 추가
        alertContainer.addSubviews(messageLabel,titleLabel,closeButton, settingsButton)
    }
    
    override func setLayout() {
        // Alert 컨테이너 중앙 배치
        alertContainer.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(ScreenUtils.width * 279 / 360)
            $0.height.greaterThanOrEqualTo(ScreenUtils.width * 279 / 360 * 0.5)
            
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(alertContainer)
            $0.top.horizontalEdges.equalTo(alertContainer).inset(ScreenUtils.width * 24 / 360)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(alertContainer).inset(ScreenUtils.width * 24 / 360)
            $0.centerX.equalTo(alertContainer)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.leading.equalTo(alertContainer.snp.leading).offset(ScreenUtils.width * 24 / 360)
            $0.trailing.equalTo(alertContainer.snp.centerX).offset(-4)
            $0.width.equalTo(ScreenUtils.width * 112 / 360)
            $0.height.equalTo(ScreenUtils.width * 44 / 360)
        }
        
        settingsButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.trailing.equalTo(alertContainer.snp.trailing).offset(-ScreenUtils.width * 24 / 360)
            $0.leading.equalTo(alertContainer.snp.centerX).offset(4)
            $0.width.equalTo(ScreenUtils.width * 112 / 360)
            $0.height.equalTo(ScreenUtils.width * 44 / 360)
            $0.bottom.equalTo(alertContainer.snp.bottom).inset(ScreenUtils.width * 24 / 360)
        }
    }
    
}
    
extension CustomAlertView {
    
    func configure(with alertType: AlertType) {
        print("AlertType: \(alertType)") // 디버깅용 출력
        print("Title: \(alertType.title)")
        print("Content: \(alertType.content)")
        
        titleLabel.text = alertType.title
        messageLabel.text = alertType.content
        
        let buttonTitles = alertType.buttons
        closeButton.setAttributedTitle(
            NSAttributedString(
                string: buttonTitles[0],
                attributes: [
                    .font: ACFont.s2,
                    .foregroundColor: UIColor.gray3
                ]
            ),
            for: .normal
        )
        
        settingsButton.setAttributedTitle(
            NSAttributedString(
                string: buttonTitles[1],
                attributes: [
                    .font: ACFont.s2,
                    .foregroundColor: UIColor.acWhite
                ]
            ),
            for: .normal
        )
        self.view.layoutIfNeeded()

    }


    
    // MARK: - Actions
    @objc private func closeTapped() {
        dismiss(animated: true) {
            self.onClose?()
        }
    }
    
    @objc private func actionTapped() {
        dismiss(animated: true) {
            //            self.onAction?()
        print("hi")
        }
        
    }
    
}

#if DEBUG
import SwiftUI

struct CustomAlertViewPreview: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> CustomAlertView {
        let alertView = CustomAlertView()
        alertView.onClose = {
            print("Close button tapped")
        }
        alertView.onSettings = {
            print("Settings button tapped")
        }
        return alertView
    }
    
    func updateUIViewController(_ uiViewController: CustomAlertView, context: Context) {
        // 업데이트 로직이 필요하면 여기에 추가
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertViewPreview()
            .edgesIgnoringSafeArea(.all) // 화면 전체를 덮도록 설정
    }
}
#endif


//
//
//let customAlertView = CustomAlertView()
//customAlertView.configure(with: .stoppedPreferenceAnalysis)
