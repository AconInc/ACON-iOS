//
//  CustomAlertViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/20/25.

import UIKit

final class ACAlertViewController: BaseViewController {
    
    // MARK: - UI Properties
    
    let customAlertView: ACAlertView = ACAlertView()
    
    
    // MARK: - Properties
    
    var customAlertType: ACAlertType
    
    var onLongButtonTapped: (() -> Void)?
    
    var onLeftButtonTapped: (() -> Void)?
    
    var onRightButtonTapped: (() -> Void)?
    
    
    // MARK: - LifeCycle
    
    init(_ customAlertType: ACAlertType) {
        self.customAlertType = customAlertType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(with: customAlertType)
        addTarget()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        view.addSubview(customAlertView)
        customAlertView.frame = view.bounds
    }
    
}


// MARK: - Setting methods

private extension ACAlertViewController {
    
    func addTarget() {
        customAlertView.longButton.addTarget(self, action: #selector(longButtonTapped), for: .touchUpInside)
        customAlertView.leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        customAlertView.rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    func configure(with alertType: ACAlertType) {
        customAlertView.configure(title: alertType.title,
                                  description: alertType.description,
                                  longButtonTitle: alertType.longButtonTitle,
                                  leftButtonTitle: alertType.leftButtonTitle,
                                  rightButtonTitle: alertType.rightButtonTitle)
    }
    
}


// MARK: - @objc functions

private extension ACAlertViewController {
    
    @objc
    func longButtonTapped() {
        dismiss(animated: true) {
            self.onLongButtonTapped?()
        }
    }
    
    @objc
    func leftButtonTapped() {
        dismiss(animated: true) {
            self.onLeftButtonTapped?()
        }
    }
    
    @objc
    func rightButtonTapped() {
        dismiss(animated: true) {
            self.onRightButtonTapped?()
        }
    }
    
}
