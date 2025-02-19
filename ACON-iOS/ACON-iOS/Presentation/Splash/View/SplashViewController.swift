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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            self.goToNextVC()
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
    func goToNextVC() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        
        let hasToken = AuthManager.shared.hasToken
        let hasVerifiedArea = AuthManager.shared.hasVerifiedArea
        
        var rootVC: UIViewController
        
        // NOTE: 자동로그인O && 지역인증O -> TabBar로 이동
        if hasToken && hasVerifiedArea {
            rootVC = ACTabBarController()
        }
        
        // NOTE: 자동로그인O && 지역인증X -> 지역인증으로 이동
        else if hasToken && !hasVerifiedArea {
            let vm = LocalVerificationViewModel(flowType: .onboarding)
            // TODO: 자동으로 맵뷰로 넘어가는 문제 해결
            rootVC = UINavigationController(
                rootViewController: LocalVerificationViewController(viewModel: vm)
            )
        }
        
        // NOTE: 자동로그인X -> 로그인VC로 이동
        else {
            rootVC = UINavigationController(
                rootViewController: LoginViewController()
            )
        }
        
        sceneDelegate?.window?.rootViewController = rootVC
    }
    
}
