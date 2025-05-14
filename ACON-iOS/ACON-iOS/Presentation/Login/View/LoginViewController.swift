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
        self.setSkipButton()
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

extension LoginViewController {
    
    func bindViewModel() {
        self.loginViewModel.onSuccessLogin.bind { [weak self] onSuccess in
            guard let onSuccess else { return }
            guard let self = self else { return }
            let hasVerifiedArea = loginViewModel.hasVerifiedArea
            if onSuccess {
                AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.login, properties: ["did_login?": true])
                hasVerifiedArea ? switchRootToTabBar() : navigateToLocalVerificationVC()
            } else {
                showLoginFailAlert()
            }
        }
    }
    
    func navigateToLocalVerificationVC() {
        let vm = LocalVerificationViewModel(flowType: .onboarding)
        let vc = LocalVerificationViewController(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func switchRootToTabBar() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = ACTabBarController()
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
