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
        if AuthManager.shared.hasToken {
            viewModel.getProfile()
        }
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
        
        self.setCenterTitleLabelStyle(title: StringLiterals.Profile.profilePageTitle, fontStyle: .h5)
        self.setSettingButton()
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
        
    }
    
}


private extension ProfileViewController {
    
    func bindViewModel() {
        viewModel.onLoginSuccess.bind { [weak self] onLoginSuccess in
            guard let self = self,
                  let onLoginSuccess = onLoginSuccess
            else { return }
            
            self.profileView.do {
                $0.needLoginButton.isHidden = onLoginSuccess
                $0.setAcornCountBox(onLoginSuccess: onLoginSuccess)
                $0.setVerifiedAreaBox(onLoginSuccess: onLoginSuccess)
            }
        }
        
        viewModel.onGetProfileSuccess.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }
            // TODO: onSuccess 분기처리
            // TODO: 인증동네 추후 여러개로 수정(Sprint3)
            let firstAreaName: String = self.viewModel.userInfo.verifiedAreaList.first?.name ?? "???"
            if onSuccess {
                profileView.do {
                    $0.setProfileImage(self.viewModel.userInfo.profileImage)
                    $0.setNicknameLabel(self.viewModel.userInfo.nickname)
                    $0.setAcornCountBox(self.viewModel.userInfo.possessingAcorns)
                    $0.setVerifiedAreaBox(areaName: firstAreaName)
                }
            } else {
                self.showDefaultAlert(title: "프로필 로드 실패", message: "프로필 정보 로드에 실패했습니다.")
            }
        }
    }
    
}

// MARK: - @objc functions

private extension ProfileViewController {
    
    @objc
    func tappedNeedLoginButton() {
//        presentLoginModal() // TODO: 메소드 수정 고민해보기 (SpotListVC도 로그인 성공했을 때 reloadData 시켜야할 것 같기 때문)
        let vc = LoginModalViewController()
        vc.setSheetLayout(detent: .short)
        vc.onSuccessLogin = { [weak self] onSuccess in
            guard let self = self else { return }
            viewModel.onLoginSuccess.value = onSuccess
            viewModel.getProfile()
        }
        
        self.present(vc, animated: true)
    }
    
    @objc
    func tappedEditProfileButton() {
        let vc = ProfileEditViewController(viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
