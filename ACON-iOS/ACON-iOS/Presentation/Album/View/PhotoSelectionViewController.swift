//
//  PhotoSelectionViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/16/25.
//

import UIKit

import SnapKit
import Then

class PhotoSelectionViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let profileImageView = UIImageView()
    
    private let dimImageView = UIImageView()

    
    // MARK: - Properties
    
    var profileImage: UIImage
    
    
    // MARK: - LifeCycle
    
    init(_ profileImage: UIImage) {
        self.profileImage = profileImage
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.contentView.addSubviews(profileImageView, dimImageView)
    }
    
    override func setLayout() {
        super.setLayout()

        profileImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.width)
            $0.centerY.equalToSuperview().offset(-50)
        }
        
        dimImageView.snp.makeConstraints {
            $0.edges.equalTo(profileImageView.snp.edges)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setCenterTitleLabelStyle(title: "프로필 사진")
        self.setBackButton()
        self.setDoneButton()
        
        profileImageView.do {
            $0.backgroundColor = .labelAction
            $0.image = profileImage
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        
        dimImageView.do {
            $0.backgroundColor = .clear
            $0.image = .cmpProfileSelectedImgLayout
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func addTarget() {
        self.rightButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }

}


// MARK: - @objc methods

private extension PhotoSelectionViewController {
    
    @objc
    func doneButtonTapped() {
        guard let navigationController = self.navigationController,
              let vc = navigationController.viewControllers.first(where: { $0 is ProfileEditViewController }) as? ProfileEditViewController else {
            return
        }
        vc.updateProfileImage(profileImage, false)
        navigationController.popToViewController(vc, animated: true)
    }
    
}

