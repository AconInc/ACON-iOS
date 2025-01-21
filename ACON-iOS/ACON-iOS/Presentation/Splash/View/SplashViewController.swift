//
//  SplashViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import UIKit

class SplashViewController: BaseViewController {
    
    // MARK: - UI Properties
    
    private let splashView = SplashView()
    
    
    // MARK: - LifeCycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        splashView.splashLottieView.do {
            $0.play()
        }
        
        splashView.logoLabel.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.3) {
                self.splashView.logoLabel.alpha = 1
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.goToLoginVC()
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.view.addSubview(splashView)
    }
    
    override func setLayout() {
        super.setLayout()

        splashView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}


// MARK: - GoToLoginVC

private extension SplashViewController {
    
    @objc
    func goToLoginVC() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = LoginViewController()
        }
    }
    
}
