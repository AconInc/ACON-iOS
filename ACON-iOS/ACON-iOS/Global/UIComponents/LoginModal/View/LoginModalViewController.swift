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
            print("hi")
            print(onSuccess)
            guard let onSuccess else { return }
            guard let self = self else { return }
            self.dismiss(animated: true)
            onSuccess ? ACToastController.show(StringLiterals.LoginModal.successLogin, bottomInset: 112, delayTime: 1) { [weak self] in return } : showLoginFailAlert()
        }
    }
    
    func navigateToLocalVerificationVC() {
        let vc = LocalVerificationViewController()
        self.navigationController?.pushViewController(vc, animated: false)
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
        self.showLoginFailAlert()
    }
    
}
