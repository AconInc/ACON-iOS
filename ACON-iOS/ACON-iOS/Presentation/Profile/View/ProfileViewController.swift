//
//  ProfileViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/11/25.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    private let profileView = ProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        view.addSubview(profileView)

    }
    
    override func setLayout() {
        super.setLayout()
        
        profileView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func addTarget() {
        profileView.disableAutoLoginButton.addTarget(self,
                                                     action: #selector(disableAutoLogin),
                                                     for: .touchUpInside)
    }
    
    @objc
    func disableAutoLogin() {
        print("djlkdsjlfes")
    }
    
}
