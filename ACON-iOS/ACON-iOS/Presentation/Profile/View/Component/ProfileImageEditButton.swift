//
//  ProfileImageEditButton.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import UIKit

import Kingfisher

final class ProfileImageEditButton: UIView {
    
    // MARK: - Helpers
    
    private let size: CGFloat
    
    private let cameraImageSize: Int = 25
    
    
    // MARK: - UI Components
    
    private let profileImageView = UIImageView()
    
    private let cameraButton = UIButton()
    
    
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
            $0.backgroundColor = .gray7 // NOTE: Skeleton
            $0.layer.cornerRadius = size / 2
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        cameraButton.do {
            $0.setImage(.icProfileImgEdit, for: .normal)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(
            profileImageView,
            cameraButton
        )
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.size.equalTo(size)
        }
        
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cameraButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(profileImageView)
        }
    }
    
}


// MARK: - Internal Methods

extension ProfileImageEditButton {
    
    func setImage(_ image: UIImage) {
        profileImageView.image = image
    }
    
    func setImageURL(_ imageURL: String) {
        profileImageView.kf.setImage(
            with: URL(string: imageURL),
            options: [.transition(.none), .cacheOriginalImage]
        )
    }

    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        cameraButton.addTarget(target, action: action, for: controlEvents)
    }
    
}
