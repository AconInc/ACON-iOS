//
//  LoginViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/11/25.
//

import UIKit

import SnapKit
import Then

class LoginViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let loginView = LoginView()
    
    
    // MARK: - Properties
    
    private let viewModel = LoginViewModel()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.setSkipButton()
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
    }
}


// MARK: - @objc functions

extension LoginViewController {

    @objc
    func googleLoginButtonTapped() {
        viewModel.googleSignIn(presentingViewController: self)
    }
    
}
