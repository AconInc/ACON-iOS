//
//  SpotListGoogleAdCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/4/25.
//

import UIKit

import GoogleMobileAds
import SkeletonView

class SpotListGoogleAdCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Properties
    
    private let glassmorphismView: GlassmorphismView = GlassmorphismView(.buttonGlassDefault)
    
    private let nativeAdView = NativeAdView()
    
    private let adButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_19_b1R), title: "광고")
    
    private let headlineLabel = UILabel()
    
    private let bodyLabel = UILabel()
    
    private let iconImageView = UIImageView()
    
    private let mediaView = MediaView()

    private let callToActionButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_10_b1SB))

    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setNativeAdView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHierarchy() {
        contentView.addSubviews(glassmorphismView, nativeAdView)

        nativeAdView.addSubviews(mediaView,
                                 adButton,
                                 headlineLabel,
                                 bodyLabel,
                                 iconImageView,
                                 callToActionButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        let edge = ScreenUtils.widthRatio * 20
        
        glassmorphismView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nativeAdView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        adButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(52*ScreenUtils.heightRatio)
            $0.leading.equalToSuperview().inset(edge)
            $0.width.equalTo(48)
            $0.height.equalTo(38)
        }
        
        iconImageView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(edge)
            $0.size.equalTo(36)
        }
        
        headlineLabel.snp.makeConstraints {
            $0.top.leading.equalTo(edge)
            $0.width.equalTo(250)
            $0.height.equalTo(24)
        }
        
        bodyLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(61*ScreenUtils.heightRatio)
            $0.horizontalEdges.equalToSuperview().inset(edge)
            $0.height.equalTo(60)
        }
        
        mediaView.snp.makeConstraints {
            $0.top.equalTo(adButton.snp.bottom).offset(13*ScreenUtils.heightRatio)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(150*ScreenUtils.heightRatio)
        }
        
        callToActionButton.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(edge)
            $0.width.equalTo(140)
            $0.height.equalTo(36)
        }
    }
    
    override func setStyle() {
        [glassmorphismView, nativeAdView, iconImageView, headlineLabel, callToActionButton].forEach {
            $0.isSkeletonable = true
            $0.skeletonCornerRadius = 8
        }
        
        contentView.do {
            $0.layer.cornerRadius = 12
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowRadius = 4
            $0.layer.shadowOpacity = 0.1
            $0.backgroundColor = .clear
        }
        
        headlineLabel.linesCornerRadius = 8
        
        iconImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.backgroundColor = .systemGray6
        }

        mediaView.do {
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }

        [adButton, callToActionButton].forEach {
            $0.do {
                $0.updateGlassButtonState(state: .default)
                $0.isUserInteractionEnabled = false
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nativeAdView.nativeAd = nil
        hideSkeleton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        glassmorphismView.layer.cornerRadius = 12
        glassmorphismView.clipsToBounds = true
        
        glassmorphismView.refreshBlurEffect()
        adButton.refreshButtonBlurEffect(.buttonGlassDefault)
        callToActionButton.refreshButtonBlurEffect(.buttonGlassDefault)
    }
}


// MARK: - Configure

extension SpotListGoogleAdCollectionViewCell {
    
    private func setNativeAdView() {
        nativeAdView.do {
            $0.headlineView = headlineLabel
            $0.bodyView = bodyLabel
            $0.callToActionView = callToActionButton
            $0.iconView = iconImageView
            $0.mediaView = mediaView
        }
    }
    
    func configure(with nativeAd: NativeAd) {
        nativeAdView.isHidden = false
        
        // TODO: 🍇 주석 해제
//        endSkeletonAnimation()
        
        if let headline = nativeAd.headline {
            headlineLabel.setLabel(text: headline, style: .t4SB)
            headlineLabel.isHidden = false
        } else {
            headlineLabel.isHidden = true
        }
        
        if let body = nativeAd.body {
            bodyLabel.setLabel(text: body, style: .b1R)
            bodyLabel.isHidden = false
        } else {
            bodyLabel.isHidden = true
        }
        
        if let callToAction = nativeAd.callToAction {
            callToActionButton.updateButtonTitle(callToAction)
        } else {
            callToActionButton.updateButtonTitle("자세히 보기")
        }
        
        if let icon = nativeAd.icon {
            iconImageView.image = icon.image
            iconImageView.isHidden = false
        } else {
            iconImageView.isHidden = true
        }
        
        let mediaContent = nativeAd.mediaContent
        mediaView.mediaContent = mediaContent
        
        nativeAdView.nativeAd = nativeAd
    }
    
}
