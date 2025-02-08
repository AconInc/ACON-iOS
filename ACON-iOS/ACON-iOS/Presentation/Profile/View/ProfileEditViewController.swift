//
//  ProfileEditViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import UIKit

class ProfileEditViewController: BaseNavViewController {
    
    // MARK: - Properties
    
    private let profileEditView = ProfileEditView()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        contentView.addSubview(profileEditView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        profileEditView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setCenterTitleLabelStyle(title: StringLiterals.Profile.profileEditPageTitle)
        self.setBackButton()
    }
    
    private func bindViewModel() {
        // TODO: ViewModel 바인딩
        profileEditView.setProfileImage(.imgProfileBasic60)
        
        profileEditView.setNicknameValidMessage(.nicknameTaken)
        
        profileEditView.setBirthdateValidMessage(.invalidChar)
        
        profileEditView.setVerifiedAreaValidMessage(.none)
    }
    
}
