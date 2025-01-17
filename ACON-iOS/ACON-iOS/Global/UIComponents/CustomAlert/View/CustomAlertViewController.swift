//
//  CustomAlertViewController.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/16/25.

import UIKit

import SnapKit
import Then

final class CustomAlertViewController: BaseViewController {
    
    private let customAlertView = CustomAlertView()
    var onClose: (() -> Void)?
    var onSettings: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        setActions()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        view.addSubview(customAlertView)
        customAlertView.frame = view.bounds
    }
    
}


extension CustomAlertViewController {
    
    private func setActions() {
        customAlertView.closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        customAlertView.settingsButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
    }
    
    func configure(with alertType: AlertType) {
        customAlertView.configure(
            title: alertType.title,
            message: alertType.content,
            leftButton: alertType.buttons[0],
            rightButton: alertType.buttons[1]
        )
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true) {
            self.onClose?()
        }
    }
    
    @objc private func actionTapped() {
        dismiss(animated: true) {
            self.onSettings?()
        }
    }
    
}
