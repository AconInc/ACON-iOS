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
    }
}


// MARK: - @objc functions

extension LoginViewController {

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
        self.loginViewModel.onLoginSuccess.bind { [weak self] onLoginSuccess in
            guard let onLoginSuccess else { return }
            guard let self = self else { return }
            onLoginSuccess ? navigateToLocalVerificationVC() : print("로그인 실패")
        }
    }
    
    // TODO: - 나중에 서버 로그인 Success 시 이동하는 것으로 변경 (ObservablePattern)
    func navigateToLocalVerificationVC() {
        let vc = ViewController()
        self.navigationController?.pushViewController(vc, animated: false)
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
        // TODO: - 에러 처리
        print("apple login error")
    }
    
}
