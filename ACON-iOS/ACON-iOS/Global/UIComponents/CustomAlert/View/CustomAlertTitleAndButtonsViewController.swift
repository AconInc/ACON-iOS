//
//  CustomAlertTitleAndButtonsViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/19/25.
//

import UIKit

import SnapKit
import Then

final class CustomAlertTitleAndButtonsViewController: BaseViewController {
    
    private let customAlertView = CustomAlertTitleAndButtonsView()
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


extension CustomAlertTitleAndButtonsViewController {
    
    private func setActions() {
        customAlertView.closeButton.addTarget(
            self,
            action: #selector(closeTapped),
            for: .touchUpInside
        )
        customAlertView.settingsButton.addTarget(
            self,
            action: #selector(actionTapped),
            for: .touchUpInside
        )
    }
    
    func configure(with alertType: AlertType) {
        customAlertView.configure(
            title: alertType.title,
            leftButton: alertType.buttons[0],
            rightButton: alertType.buttons[1]
        )
    }
    
    func reConfigureTitle(title: String) {
        customAlertView.reConfigureTitle(title)
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
