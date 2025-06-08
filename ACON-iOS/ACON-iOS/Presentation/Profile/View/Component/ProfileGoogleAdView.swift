//
//  ProfileGoogleAdView.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/7/25.
//

import UIKit

import GoogleMobileAds

class ProfileGoogleAdView: BaseView {
    
    // MARK: - UI Properties
    
    private let glassmorphismView: GlassmorphismView = GlassmorphismView(.buttonGlassDefault)
    
    private let nativeAdView = NativeAdView()
    
    private let adButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_14_b1R), title: "광고")
    
    private let headlineLabel = UILabel()
    
    private let bodyLabel = UILabel()
    
    private let iconImageView = UIImageView()
    
    private let mediaView = MediaView()

    private let callToActionButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_10_b1SB))
    
    private let skeletonView = SkeletonView()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setNativeAdView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHierarchy() {
        self.addSubviews(glassmorphismView, nativeAdView, skeletonView)

        nativeAdView.addSubviews(mediaView,
                                 adButton,
                                 headlineLabel)
    }
    
    override func setLayout() {
        super.setLayout()

        glassmorphismView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nativeAdView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        skeletonView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        adButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.width.equalTo(48)
            $0.height.equalTo(28)
        }
        
        headlineLabel.snp.makeConstraints {
            $0.top.leading.equalTo(ScreenUtils.horizontalInset)
            $0.width.equalTo(210)
            $0.height.equalTo(24)
        }

        mediaView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        self.do {
            $0.layer.cornerRadius = 12
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowRadius = 4
            $0.layer.shadowOpacity = 0.1
            $0.backgroundColor = .clear
        }
        
        skeletonView.isHidden = true
        
        mediaView.do {
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }

        adButton.do {
            $0.isUserInteractionEnabled = false
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        glassmorphismView.layer.cornerRadius = 12
        glassmorphismView.clipsToBounds = true
        
        glassmorphismView.refreshBlurEffect()
        glassmorphismView.setGradient(bottomColor: .gray900.withAlphaComponent(0),
                                       endPoint: CGPoint(x: 0.5, y: 0.5))
        adButton.updateGlassButtonState(state: .default)
    }
    
}


// MARK: - Configure

extension ProfileGoogleAdView {
    
    private func setNativeAdView() {
        nativeAdView.do {
            $0.headlineView = headlineLabel
            $0.mediaView = mediaView
        }
    }
    
    func configure(with nativeAd: NativeAd) {
        nativeAdView.nativeAd = nil
        nativeAd.delegate = self
        
        nativeAdView.isHidden = false
        skeletonView.isHidden = true
        
        if let headline = nativeAd.headline {
            headlineLabel.setLabel(text: headline, style: .t4SB)
            headlineLabel.isHidden = false
        } else {
            headlineLabel.isHidden = true
        }
 
        let mediaContent = nativeAd.mediaContent
        mediaView.mediaContent = mediaContent
        
        nativeAdView.nativeAd = nativeAd
    }
    
}


// MARK: - Empty Cell

extension ProfileGoogleAdView {
    
    func showSkeleton() {
        nativeAdView.isHidden = true
        // TODO: - 스켈레톤 애니메이션 적용
    }
    
}


// MARK: - NativeAdDelegate

extension ProfileGoogleAdView: NativeAdDelegate {
    
    // TODO: - 광고 관련 기록 -> 추후 엠플 사용?
    func nativeAdDidRecordClick(_ nativeAd: NativeAd) {
        print("Profile 광고 클릭됨")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: NativeAd) {
        print("Profile 광고 인식됨")
    }
    
}
