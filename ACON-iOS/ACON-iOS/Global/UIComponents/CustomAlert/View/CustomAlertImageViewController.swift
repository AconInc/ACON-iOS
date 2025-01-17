//
//  CustomAlertImageViewController.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/16/25.
//

import UIKit

import SnapKit
import Then

final class CustomAlertImageViewController: BaseViewController {
    
    private let customAlertImageView = CustomAlertImageView()
    var onClose: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        setAction()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        view.addSubview(customAlertImageView)
        customAlertImageView.frame = view.bounds
    }
    
}


extension CustomAlertImageViewController {
    
    private func setAction() {
        customAlertImageView.closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
    
    func configure(with alertType: AlertType) {
        customAlertImageView.configure(
            title: alertType.title,
            message: alertType.content,
            buttonText: alertType.buttons[0]
        )
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true) {
            self.onClose?()
        }
    }
    
}
