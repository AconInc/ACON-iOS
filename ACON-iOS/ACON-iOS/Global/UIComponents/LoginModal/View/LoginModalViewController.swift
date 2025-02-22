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
    
    
    // MARK: - LifeCycle
    
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
        loginModalView.exitButton.addTarget(self,
                                            action: #selector(exitButtonTapped),
                                            for: .touchUpInside)
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
    func exitButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc
    func privacyPolicyLabelTapped() {
        let privacyPolicyVC = DRWebViewController(urlString: StringLiterals.WebView.privacyPolicyLink)
        self.present(privacyPolicyVC, animated: true)
    }
    
    @objc
    func termsOfUseLabelTapped() {
        let termsOfUseVC = DRWebViewController(urlString: StringLiterals.WebView.termsOfUseLink)
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
            
            let hasVerifiedArea = loginViewModel.hasVerifiedArea
            if onSuccess {
                if hasVerifiedArea {
                    ACToastController.show(
                        StringLiterals.LoginModal.successLogin,
                        bottomInset: 112,
                        delayTime: 1
                    ) { return }
                    
                    let authStatus = ACLocationManager.shared.locationManager.authorizationStatus
                    if authStatus == .denied || authStatus == .restricted {
                        navigateToLocalVerificationVC()
                    } else {
                        switchRootToTabBar()
                    }
                } else {
                    print("🥑onSuccess && !hasVerifiedArea")
                    navigateToLocalVerificationVC()
                }
                AmplitudeManager.shared.trackEventWithProperties("did_login", properties: ["is_modal": true])
            } else {
                showLoginFailAlert()
            }
        }
    }
    
    func switchRootToTabBar() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = ACTabBarController()
        }
    }
    
    func navigateToLocalVerificationVC() {
        let vm = LocalVerificationViewModel(flowType: .onboarding)
        let vc = LocalVerificationViewController(viewModel: vm)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: vc)
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
