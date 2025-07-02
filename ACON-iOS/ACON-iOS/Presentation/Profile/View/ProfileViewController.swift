//
//  ProfileViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/11/25.
//

import UIKit

final class ProfileViewController: BaseNavViewController {

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

        self.setCenterTitleLabelStyle(title: StringLiterals.Profile.profilePageTitle)
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
        
        profileView.savedSpotButton.addTarget(
            self,
            action: #selector(tappedSavedSpotButton),
            for: .touchUpInside
        )
    }
}


// MARK: - Bindings

private extension ProfileViewController {

    func bindViewModel() {
        viewModel.onLoginSuccess.bind { [weak self] onLoginSuccess in
            guard let self = self,
                  let onLoginSuccess = onLoginSuccess
            else { return }

            self.profileView.do {
                $0.setGuestUI(!onLoginSuccess)
            }
        }

        viewModel.onGetProfileSuccess.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }
            if onSuccess {
                profileView.do {
                    $0.setProfileImage(self.viewModel.userInfo.profileImage)
                    $0.setNicknameLabel(self.viewModel.userInfo.nickname)
                    $0.setSavedSpotUI(!self.viewModel.userInfo.savedSpotList.isEmpty)
                }
                updateSavedSpots(self.viewModel.userInfo.savedSpotList)
            } else {
                profileView.setSavedSpotUI(false)
            }
            viewModel.onGetProfileSuccess.value = nil
        }
    }

}

// MARK: - @objc functions

private extension ProfileViewController {

    @objc
    func tappedNeedLoginButton() {
        presentLoginModal(nil)
        // TODO: 메소드 수정 고민해보기 (SpotListVC도 로그인 성공했을 때 reloadData 시켜야할 것 같기 때문)
        let vc = LoginModalViewController("profile")
        vc.setSheetLayout(detent: .middle)
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
    
    @objc
    func tappedSavedSpotButton() {
        let vc = SavedSpotsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func savedSpotViewTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }

        let selectedSpotID = viewModel.userInfo.savedSpotList[view.tag].id
        let vc = SpotDetailViewController(selectedSpotID)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


// MARK: - StackView 업데이트

private extension ProfileViewController {
    
    func updateSavedSpots(_ dataList: [SavedSpotModel]) {
        profileView.savedSpotStackView.removeAllArrangedSubviews()
        
        for (index, data) in dataList.enumerated() {
            let savedSpotView = makeSavedSpotView(data, index)
            profileView.savedSpotStackView.addArrangedSubview(savedSpotView)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.profileView.savedSpotScrollView.layoutIfNeeded()
        }
    }
    
    
    func makeSavedSpotView(_ data: SavedSpotModel, _ index: Int) -> SavedSpotView {
        let savedSpotView = SavedSpotView()
        
        savedSpotView.snp.makeConstraints {
            $0.width.equalTo(150*ScreenUtils.widthRatio)
            $0.height.equalTo(217*ScreenUtils.heightRatio)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(savedSpotViewTapped(_:)))
        
        savedSpotView.do {
            $0.addGestureRecognizer(tapGesture)
            $0.tag = index
            $0.isUserInteractionEnabled = true
            $0.bindData(data)
        }
        
        return savedSpotView
    }
    
}
