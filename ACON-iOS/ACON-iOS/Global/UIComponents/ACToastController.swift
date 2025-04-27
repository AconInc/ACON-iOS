//
//  ACToastController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/17/25.
//

import UIKit

import SnapKit
import Then

final class ACToastController {
    static func show(_ message: String,
                     bottomInset: Int = 92,
                     delayTime: Double = 2.0,
                     buttonTitle: String = "",
                     buttonAction: @escaping () -> Void) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let toastView = ACToastView(message: message,
                                  buttonTitle: buttonTitle,
                                  buttonAction: buttonAction)
        
        window.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.heightRatio*42)
            $0.bottom.equalToSuperview().inset(Int(ScreenUtils.height)*bottomInset/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*20)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
            UIView.animate(withDuration: delayTime) {
                toastView.alpha = 0
            } completion: { _ in
                toastView.removeFromSuperview()
            }
        }
    }
}

final class ACToastView: BaseView {
    
    // NOTE: 액션버튼은 나중에 사용될 것 같은데 앱잼 기간 내엔 없어서 일단 프로퍼티로마 두고 addSubview는 안할게요
    private let messageLabel = UILabel()
    private let actionButton = UIButton()
    
    init(message: String,
         buttonTitle: String,
         buttonAction: @escaping () -> Void) {
        super.init(frame: .zero)
        
        setUI()
        configure(message: message,
                  buttonTitle: buttonTitle,
                  buttonAction: buttonAction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubviews(messageLabel)
        
        messageLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*18)
            $0.centerY.equalToSuperview()
        }
                
        backgroundColor = .gray800
        layer.cornerRadius = 4
    }
    
    private func configure(message: String,
                           buttonTitle: String,
                           buttonAction: @escaping () -> Void) {
        messageLabel.setLabel(text: message, style: .t4(.regular))
        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.addAction(UIAction { _ in
            buttonAction()
        }, for: .touchUpInside)
    }
    
}
