//
//  ProfileView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/17/25.
//

import UIKit

import Kingfisher
import Then
import SnapKit

final class ProfileView: BaseView {

    // MARK: - Helpers

    private let profileImageSize: CGFloat = 60


    // MARK: - UI Properties

    private let profileImageView = UIImageView()

    private let nicknameLabel = UILabel()

    let profileEditButton = UIButton()

    let needLoginButton = UIButton()
    
    private let savedSpotLabel = UILabel()
    
    let savedSpotButton = UIButton()
    
    private let noSavedSpotsLabel = UILabel()
    
    let savedSpotScrollView = UIScrollView()
        
    let savedSpotStackView = UIStackView()
    
    let googleAdView = ProfileGoogleAdView()
    
    
    // MARK: - UI Setting Methods

    override func setStyle() {
        super.setStyle()
        
        profileImageView.do {
            $0.backgroundColor = .gray700 // NOTE: Skeleton
            $0.layer.cornerRadius = profileImageSize / 2
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.image = .imgProfileBasic
        }

        profileEditButton.do {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .zero
            config.attributedTitle = AttributedString(StringLiterals.Profile.profileEditButton.attributedString(.b1R, .gray500))
            config.image = .icEditG
            config.imagePlacement = .trailing
            config.imagePadding = 4
            $0.configuration = config
        }

        needLoginButton.do {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .init(top: 15, leading: 0, bottom: 15, trailing: 15)
            config.attributedTitle = AttributedString(StringLiterals.Profile.needLogin.attributedString(.h4SB))
            config.image = .icArrowRight
            config.imagePlacement = .trailing
            config.imagePadding = 2
            config.background.backgroundColor = .gray900
            $0.configuration = config
        }
        
        savedSpotLabel.setLabel(text: "저장한 장소", style: .t4SB)
        
        savedSpotButton.do {
            $0.setAttributedTitle(text: "전체보기",
                                  style: .b1SB,
                                  color: .labelAction)
        }
        
        noSavedSpotsLabel.do {
            $0.setLabel(text: "저장한 장소가 없어요.", style: .b1R, color: .gray500)
            $0.isHidden = true
        }
        
        savedSpotScrollView.do {
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.contentInset = UIEdgeInsets(top: 0, left: ScreenUtils.horizontalInset, bottom: 0, right: 0)
        }
        
        savedSpotStackView.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .leading
            $0.distribution = .equalSpacing
        }
    }

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(
            profileImageView,
            nicknameLabel,
            profileEditButton,
            needLoginButton,
            savedSpotLabel,
            savedSpotButton,
            noSavedSpotsLabel,
            savedSpotScrollView,
            googleAdView
        )
        
        savedSpotScrollView.addSubview(savedSpotStackView)
    }

    override func setLayout() {
        super.setLayout()

        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40*ScreenUtils.heightRatio)
            $0.leading.equalToSuperview().offset(ScreenUtils.horizontalInset)
            $0.size.equalTo(profileImageSize)
        }

        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView).offset(4)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(ScreenUtils.horizontalInset)
        }

        profileEditButton.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(nicknameLabel)
        }

        needLoginButton.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel)
            $0.centerY.equalTo(profileImageView)
        }
        
        savedSpotLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(148*ScreenUtils.heightRatio)
            $0.leading.equalToSuperview().inset(ScreenUtils.horizontalInset)
        }
        
        savedSpotButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(142*ScreenUtils.heightRatio)
            $0.trailing.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.width.equalTo(64)
            $0.height.equalTo(36)
        }
        
        noSavedSpotsLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(174*ScreenUtils.heightRatio)
            $0.leading.equalToSuperview().inset(ScreenUtils.horizontalInset)
        }
        
        savedSpotScrollView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(217*ScreenUtils.heightRatio)
            $0.top.equalToSuperview().offset(186*ScreenUtils.heightRatio)
        }
        
        savedSpotStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        googleAdView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(423*ScreenUtils.heightRatio)
            $0.horizontalEdges.equalToSuperview().inset(20*ScreenUtils.widthRatio)
            $0.height.equalTo(125*ScreenUtils.heightRatio)
        }
    }

}


// MARK: - Internal Methods

extension ProfileView {

    func setProfileImage(_ imageURL: String) {
        profileImageView.kf.setImage(
            with: URL(string: imageURL),
            options: [.transition(.none), .cacheOriginalImage]
        )
    }

    func setNicknameLabel(_ text: String) {
        nicknameLabel.setLabel(text: text, style: .h4SB)
    }
    
    func setSavedSpotUI(_ hasSavedSpot: Bool) {
        googleAdView.snp.updateConstraints {
            if hasSavedSpot {
                $0.top.equalToSuperview().offset(423*ScreenUtils.heightRatio)
            } else {
                $0.top.equalToSuperview().offset(234*ScreenUtils.heightRatio)
            }
        }
        
        noSavedSpotsLabel.isHidden = hasSavedSpot
        [savedSpotButton, savedSpotScrollView].forEach {
            $0.isHidden = !hasSavedSpot
        }
    }
    
    func setGuestUI(_ isGuest: Bool) {
        needLoginButton.isHidden = !isGuest
        [savedSpotLabel,
         savedSpotButton,
         savedSpotScrollView].forEach {
            $0.isHidden = isGuest
        }
    }
    
}


// MARK: - 스크롤 막기

extension ProfileView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = 0
    }
    
}
