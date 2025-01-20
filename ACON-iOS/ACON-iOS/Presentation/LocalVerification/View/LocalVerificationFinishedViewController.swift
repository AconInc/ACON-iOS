//
//  LocalVerificationFinishedViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/15/25.
//

import UIKit

import SnapKit
import Then

class LocalVerificationFinishedViewController: BaseViewController {
    
    // MARK: - UI Properties
    
    private let localVerificationFinishedView = LocalVerificationFinishedView()
    
    let localName = "동교동"
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
    }
    
    var dismissCompletion: (() -> Void)?
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isBeingDismissed {
            dismissCompletion?()
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.view.addSubview(localVerificationFinishedView)
    }
    
    override func setLayout() {
        super.setLayout()

        localVerificationFinishedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        localVerificationFinishedView.titleLabel.do {
            $0.setLabel(text: StringLiterals.LocalVerification.now + localName + StringLiterals.LocalVerification.localAcornTitle,
                        style: .h6,
                        color: .acWhite)
        }
    }
    
    func addTarget() {
        localVerificationFinishedView.startButton.addTarget(self,
                                              action: #selector(startButtonTapped),
                                              for: .touchUpInside)
    }

}

    
// MARK: - @objc functions

private extension LocalVerificationFinishedViewController {
    
    @objc
    func startButtonTapped() {
        goToTabView()
    }
    
}


// MARK: - Close View

private extension LocalVerificationFinishedViewController {
    
    @objc
    func goToTabView() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = ACTabBarController()
        }
    }
    
}
