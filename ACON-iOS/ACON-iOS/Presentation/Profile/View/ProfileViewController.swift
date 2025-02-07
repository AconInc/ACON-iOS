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
        profileView.needLoginButton.isHidden = true
        profileView.setAcornCountBox(0)
        profileView.setVerifiedAreaBox("유림동")
    }
    
    func addTarget() {
        // TODO: needLoginButtonTapped
        
        // TODO: EditProfileButtonTapped
    }
}
