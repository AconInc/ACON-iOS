//
//  SplashViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import UIKit

import AVFAudio

class SplashViewController: BaseViewController {
    
    // MARK: - UI Properties
    
    private let splashView = SplashView()
    
    private var player: AVAudioPlayer?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("오디오 세션 설정 오류: \(error)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        playSplashAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let spotID = DeepLinkManager.shared.getSpotID() {
                self.goToSpotDetailVC(with: spotID)
                DeepLinkManager.shared.deepLinkParams = nil
            } else {
                self.goToNextVC()
            }
        }
    }
    
    deinit {
        player?.stop()
        player = nil
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

    // NOTE: 딥링크 진입 시 호출
    func goToSpotDetailVC(with spotID: Int64) {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

        let rootVC: UIViewController = {
            // NOTE: 자동로그인O && 지역인증X -> rootVC = 지역인증VC
            if AuthManager.shared.hasToken && !AuthManager.shared.hasVerifiedArea {
                let vm = LocalVerificationViewModel(flowType: .onboarding)
                return UINavigationController(
                    rootViewController: LocalVerificationViewController(viewModel: vm)
                )
            } else {
                // NOTE: 그 외 -> rootVC = TabBar
                return ACTabBarController()
            }
        }()

        sceneDelegate?.window?.rootViewController = rootVC
        sceneDelegate?.window?.makeKeyAndVisible()

        let spotDetailVC = SpotDetailViewController(spotID, isDeepLink: true)
        spotDetailVC.modalPresentationStyle = .fullScreen
        rootVC.present(spotDetailVC, animated: true)
    }

}


// MARK: - Splash Animation

private extension SplashViewController {
    
    func playSplashAnimation() {
        splashView.do {
            $0.splashLottieView.play()
        }
        fadeShadowImage()
        playSplashBGM()
    }
    
    func fadeShadowImage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            UIView.animate(withDuration: 0.1) {
                self.splashView.shadowImageView.alpha = 1.0
            }
        }
    }
    
    func playSplashBGM() {
        let audioSession = AVAudioSession.sharedInstance()
            
        if audioSession.secondaryAudioShouldBeSilencedHint {
            return
        }
        
        if let path = Bundle.main.path(forResource: "SplashBGM", ofType: "mp3") {
            player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player?.volume = 0.8
            player?.play()
        }
    }
    
}
