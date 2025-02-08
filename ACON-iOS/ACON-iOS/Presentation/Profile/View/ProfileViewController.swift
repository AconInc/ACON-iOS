//
//  ProfileViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/11/25.
//

import UIKit

class ProfileViewController: BaseNavViewController {
    
    private let profileView = ProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
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
        
        // TODO: 뷰모델 바인딩
        profileView.do {
            $0.needLoginButton.isHidden = true
            $0.setProfileImage(.imgProfileBasic60) // TODO: imgProfileBasic60 에셋 삭제, 서버에서 기본이미지 불러오기
            $0.setNicknameLabel("Username")
            $0.setAcornCountBox(0)
            $0.setVerifiedAreaBox("유림동")
        }
    }
    
    func addTarget() {
        // TODO: needLoginButtonTapped
        
        // TODO: EditProfileButtonTapped
        profileView.profileEditButton.addTarget(
            self,
            action: #selector(tappedEditProfileButton),
            for: .touchUpInside
        )
    }
    
    
}


// MARK: - @objc functions

private extension ProfileViewController {
    
    @objc
    func tappedEditProfileButton() {
        let vc = ProfileEditViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
