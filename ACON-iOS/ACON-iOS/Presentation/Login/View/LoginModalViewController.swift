//
//  LoginModalViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/22/25.
//

import UIKit

import AuthenticationServices

class LoginModalViewController: BaseViewController {
    
    // MARK: - UI Properties
    
    private let loginModalView = LoginModalView()
    
    
    // MARK: - Properties
    
    private let loginViewModel = LoginViewModel()
    
    var onSuccessLogin: ((Bool) -> ())?
    
    var presentedVCType: String?
    
    
    // MARK: - LifeCycle
    
    init(_ presentedVCType: String?) {
        if let presentedVCType {
            self.presentedVCType = presentedVCType
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
        bindViewModel()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.view.addSubview(loginModalView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        loginModalView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func addTarget() {
        loginModalView.googleLoginButton.addTarget(self,
                                                   action: #selector(googleLoginButtonTapped),
                                                   for: .touchUpInside)
        loginModalView.appleLoginButton.addTarget(self,
                                                  action: #selector(appleLoginButtonTapped),
                                                  for: .touchUpInside)
        
        loginModalView.privacyPolicyLabel.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                                      action: #selector(privacyPolicyLabelTapped)))
        loginModalView.termsOfUseLabel.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                                   action: #selector(termsOfUseLabelTapped)))

    }
    
}


// MARK: - @objc functions

extension LoginModalViewController {
    
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

extension LoginModalViewController {

    func bindViewModel() {
        self.loginViewModel.onSuccessLogin.bind { [weak self] onSuccess in
            guard let onSuccess else { return }
            guard let self = self else { return }
            self.onSuccessLogin?(onSuccess)
            self.dismiss(animated: true)

            let hasSeenTutorial = AuthManager.shared.hasSeenTutorial
            let hasSeenLocalVerification = AuthManager.shared.hasSeenLocalVerification
            let hasSeenPreference = AuthManager.shared.hasSeenPreference
            let hasVerifiedArea = AuthManager.shared.hasVerifiedArea
            let hasPreference = AuthManager.shared.hasPreference

            if onSuccess {
                // NOTE: [온보딩 순서] 소셜로그인 > 서비스 온보딩(튜토리얼) > 지역인증 > 취향탐색

                // NOTE: 튜토리얼X -> 튜토리얼VC
                if !hasSeenTutorial {
                    NavigationUtils.navigateToTutorial()
                }

                // NOTE: 튜토리얼O && 지역인증X -> 지역인증VC
                else if (!hasSeenLocalVerification && !hasVerifiedArea) {
                    NavigationUtils.navigateToOnboardingLocalVerification()
                }

                // NOTE: 튜토리얼O && 지역인증O && 취향탐색X -> 취향탐색VC
                else if (!hasSeenPreference && !hasPreference) {
                    NavigationUtils.naviateToOnboardingPreference()
                }

                // NOTE: 튜토리얼O && 지역인증O && 취향탐색O -> TabBar
                else {
                    NavigationUtils.navigateToTabBar()
                }

                if let presentedVCType = presentedVCType {
                    AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.guest, properties: [presentedVCType: true])
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

extension LoginModalViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential
        else { return }
        
        self.loginViewModel.appleSignIn(userInfo: credential)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        // TODO: - 에러 처리
        print("apple login error")
    }
    
}
