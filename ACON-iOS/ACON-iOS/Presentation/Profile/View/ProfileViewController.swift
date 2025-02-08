//
//  ProfileViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/11/25.
//

import UIKit

class ProfileViewController: BaseNavViewController {
    
    // MARK: - Properties
    
    private let profileView = ProfileView()
    
    private let viewModel = ProfileViewModel()
    
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        contentView.addSubview(profileView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        profileView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setCenterTitleLabelStyle(title: "프로필", fontStyle: .h5)
    }
    
    private func addTarget() {
        profileView.needLoginButton.addTarget(
            self,
            action: #selector(tappedNeedLoginButton),
            for: .touchUpInside
        )
        
        profileView.profileEditButton.addTarget(
            self,
            action: #selector(tappedEditProfileButton),
            for: .touchUpInside
        )
        
        profileView.disableAutoLoginButton.addTarget( // TODO: 삭제
            self,
            action: #selector(disableAutoLogin),
            for: .touchUpInside
        )
    }
    
}


private extension ProfileViewController {
    
    func bindViewModel() {
        viewModel.onLoginSuccess.bind { [weak self] onLoginSuccess in
            guard let self = self,
                  let onLoginSuccess = onLoginSuccess
            else { return }
            print("🥑onLoginSuccess: \(onLoginSuccess)")
            self.profileView.needLoginButton.isHidden = onLoginSuccess
        }
        
        // TODO: 뷰모델 바인딩
        profileView.do {
            $0.setProfileImage(.imgProfileBasic60) // TODO: imgProfileBasic60 에셋 삭제, 서버에서 기본이미지 불러오기
            $0.setNicknameLabel("Username")
            $0.setAcornCountBox(0)
            $0.setVerifiedAreaBox("유림동")
        }
    }
    
}

// MARK: - @objc functions

private extension ProfileViewController {
    
    @objc
    func tappedNeedLoginButton() {
//        presentLoginModal() // TODO: 메소드 수정 고민해보기 (SpotListVC도 로그인 성공했을 때 reloadData 시켜야할 것 같기 때문)
        let vc = LoginModalViewController()
        vc.setShortSheetLayout()
        vc.onSuccessLogin = { [weak self] onSuccess in
            guard let self = self else { return }
            viewModel.onLoginSuccess.value = onSuccess
        }
        
        self.present(vc, animated: true)
    }
    
    @objc
    func tappedEditProfileButton() {
        let vc = ProfileEditViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc // TODO: 삭제
    func disableAutoLogin() {
        UserDefaults.standard.removeObject(
            forKey: StringLiterals.UserDefaults.accessToken
        )
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = SplashViewController()
        }
    }
}
