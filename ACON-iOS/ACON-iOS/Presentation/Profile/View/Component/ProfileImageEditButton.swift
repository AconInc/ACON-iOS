//
//  ProfileImageEditButton.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import UIKit

class ProfileImageEditButton: UIButton {
    // MARK: - Helpers
    
    private let size: CGFloat
    
    private let cameraImageSize: Int = 25
    
    
    // MARK: - UI Components
    
    private let profileImageView = UIImageView()
    
    private let cameraImageView = UIImageView()
    
    
    // MARK: - LifeCycles
    
    init(size: CGFloat) {
        self.size = size
        
        super.init(frame: .zero)
        
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        self.backgroundColor = .gray9
        
        profileImageView.do {
            $0.layer.cornerRadius = size / 2
            $0.contentMode = .scaleAspectFill
        }
        
        cameraImageView.do {
            $0.image = .icProfileImgEdit
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(
            profileImageView,
            cameraImageView
        )
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.size.equalTo(size)
        }
        
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cameraImageView.snp.makeConstraints {
            $0.trailing.bottom.equalTo(profileImageView)
        }
    }
    
    
    // MARK: - Internal Methods
    
    override func setImage(_ image: UIImage?, for state: UIControl.State = .normal) {
        profileImageView.image = image
    }
    
}
