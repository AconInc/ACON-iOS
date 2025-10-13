//
//  LoginViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/11/25.
//

import UIKit

import AuthenticationServices
import SnapKit
import Then

class LoginViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let loginView = LoginView()
    
    
    // MARK: - Properties
    
    private let loginViewModel = LoginViewModel()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
        bindViewModel()
        self.setSkipButton {
            AuthManager.shared.hasSeenTutorial
            ? NavigationUtils.navigateToTabBar()
            : NavigationUtils.navigateToTutorial()
        }

        if BuildConfig.isDebug || Bundle.main.isTestFlight {
            setTokenLogButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loginView.loginContentView.alpha = 0
        self.rightButton.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.4) {
                self.loginView.loginContentView.alpha = 1.0
                self.rightButton.alpha = 1.0
            }
        }
    }


    // MARK: - UI Setting

    override func setHierarchy() {
        super.setHierarchy()
        
        self.contentView.addSubview(loginView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        loginView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func addTarget() {
        loginView.googleLoginButton.addTarget(self, action: #selector(googleLoginButtonTapped), for: .touchUpInside)
        loginView.appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
        
        loginView.privacyPolicyLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(privacyPolicyLabelTapped)))
        loginView.termsOfUseLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(termsOfUseLabelTapped)))

    }
    
}


// MARK: - @objc functions

extension LoginViewController {

    @objc
    func privacyPolicyLabelTapped() {
        let privacyPolicyVC = ACWebViewController(urlString: StringLiterals.WebView.privacyPolicyLink)
        self.present(privacyPolicyVC, animated: true)
    }
    
    @objc
    func termsOfUseLabelTapped() {
        let termsOfUseVC = ACWebViewController(urlString: StringLiterals.WebView.termsOfUseLink)
        self.present(termsOfUseVC, animated: true)
    }
    
    @objc
    func googleLoginButtonTapped() {
        loginViewModel.googleSignIn(presentingViewController: self)
    }
    
    @objc
    func appleLoginButtonTapped() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
}


// MARK: - bindViewModel

extension LoginViewController {
    
    func bindViewModel() {
        self.loginViewModel.onSuccessLogin.bind { [weak self] onSuccess in
            guard let onSuccess else { return }
            guard let self = self else { return }

            let hasSeenTutorial = AuthManager.shared.hasSeenTutorial
            let hasSeenLocalVerificationOnboarding = AuthManager.shared.hasSeenLocalVerification
            let hasSeenPreferenceOnboarding = AuthManager.shared.hasSeenPreference

            if onSuccess {
                AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.login, properties: ["did_login?": true])

                // NOTE: [온보딩 순서] 소셜로그인 > 서비스 온보딩(튜토리얼) > 지역인증 > 취향탐색

                // NOTE: 튜토리얼X -> 튜토리얼VC
                if !hasSeenTutorial {
                    NavigationUtils.navigateToTutorial()
                }

                // NOTE: 튜토리얼O && 지역인증X -> 지역인증VC
                else if !hasSeenLocalVerificationOnboarding {
                    NavigationUtils.navigateToOnboardingLocalVerification()
                }

                // NOTE: 튜토리얼O && 지역인증O && 취향탐색X -> 취향탐색VC
                else if !hasSeenPreferenceOnboarding {
                    NavigationUtils.naviateToOnboardingPreference()
                }

                // NOTE: 튜토리얼O && 지역인증O && 취향탐색O -> TabBar
                else {
                    NavigationUtils.navigateToTabBar()
                }
            } else {
                showLoginFailAlert()
            }
        }
    }
    
    func showLoginFailAlert() {
        self.showDefaultAlert(title: StringLiterals.Alert.loginFailTitle,
                              message: StringLiterals.Alert.loginFailMessage)
    }
    
}


// MARK: - Apple Login Functions

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential
        else { return }
        
        self.loginViewModel.appleSignIn(userInfo: credential)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        print("apple login error")
    }
    
}


// MARK: - Set Token Log Button

private extension LoginViewController {

    func setTokenLogButton() {
        _ = UIButton().then {
            navigationBarView.addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(20)
                $0.leading.centerY.equalToSuperview()
            }
            $0.backgroundColor = .clear
            $0.addTarget(self, action: #selector(presentTokenLogVC), for: .touchUpInside)
        }
    }

    @objc
    func presentTokenLogVC() {
        let tokenLogVC = TokenLogViewController()
        self.present(tokenLogVC, animated: true)
    }

}
