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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.goToLoginVC()
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.view.addSubview(splashView)
    }
    
    override func setLayout() {
        super.setLayout()

        splashView.splashLottieView.do {
            $0.play()
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
