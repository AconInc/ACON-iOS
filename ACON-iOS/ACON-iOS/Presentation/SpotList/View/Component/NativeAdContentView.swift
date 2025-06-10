//
//  NativeAdContentView.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/10/25.
//

import UIKit

import GoogleMobileAds

class NativeAdContentView: BaseView {
    
    // MARK: - UI Properties
    
    private let glassmorphismView: GlassmorphismView = GlassmorphismView(.buttonGlassDefault)
    
    let nativeAdView = NativeAdView()
    
    private let adButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_19_b1R), title: "광고")
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("⚠️NativeAdView의 모든 서브뷰:")
        for (index, subview) in nativeAdView.subviews.enumerated() {
            print("  [\(index)] \((subview)): \(subview.frame)")
            if subview.frame.maxX > nativeAdView.bounds.width ||
               subview.frame.maxY > nativeAdView.bounds.height {
                print(" \(subview)⚠️ 이 뷰가 경계를 벗어남! \n 타입: ⚠️ \(type(of: subview)), 프레임: \(subview.frame)")
            }
        }
        
        glassmorphismView.layer.cornerRadius = 12
        glassmorphismView.clipsToBounds = true
        
        glassmorphismView.refreshBlurEffect()
        adButton.updateGlassButtonState(state: .default)
        callToActionButton.updateGlassButtonState(state: .default)
    }
    
    
    // MARK: - Setup Methods
    
    override func setHierarchy() {
        addSubviews(glassmorphismView, nativeAdView)

        nativeAdView.addSubviews(mediaView,
                                 adButton,
                                 headlineLabel,
                                 bodyLabel,
                                 iconImageView,
                                 callToActionButton)
    }
    
    override func setLayout() {
        let edge = 20
        
        glassmorphismView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nativeAdView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
            $0.center.equalToSuperview()
            $0.width.equalTo(328)
            $0.height.equalTo(444)
        }
        
        adButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(52)
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
            $0.leading.trailing.equalToSuperview().inset(edge)
            $0.bottom.equalTo(iconImageView.snp.top).offset(-16)
            $0.height.equalTo(60)
        }
        
        mediaView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(104)
            $0.horizontalEdges.equalToSuperview()
            $0.height.lessThanOrEqualTo(212)
        }
        
        callToActionButton.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(edge)
            $0.width.equalTo(140)
            $0.height.equalTo(36)
        }
    }
    
    override func setStyle() {
        backgroundColor = .clear
        layer.cornerRadius = 12
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
        skeletonView.isHidden = true
        
        nativeAdView.clipsToBounds = true
        
        iconImageView.do {
            $0.contentMode = .scaleAspectFill
//            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.backgroundColor = .systemGray6
        }
        
        mediaView.do {
//            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }

        [adButton, callToActionButton].forEach {
            $0.do {
                $0.updateGlassButtonState(state: .default)
                $0.isUserInteractionEnabled = false
            }
        }
    }
    
    private func setNativeAdView() {
        nativeAdView.do {
            $0.headlineView = headlineLabel
            $0.bodyView = bodyLabel
            $0.callToActionView = callToActionButton
            $0.iconView = iconImageView
            $0.mediaView = mediaView
            $0.advertiserView = bodyLabel
            $0.adChoicesView = nil
        }
    }
}


// MARK: - Internal Methods

extension NativeAdContentView {

    func configure(with nativeAd: NativeAd) {
        setNeedsLayout()
        layoutIfNeeded()
        
        nativeAdView.isHidden = false
        skeletonView.isHidden = true
        
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
        
        DispatchQueue.main.async {
            self.nativeAdView.clipsToBounds = true
            self.nativeAdView.layer.masksToBounds = true
        }
        
        nativeAdView.nativeAd = nativeAd
    }
    
    func showSkeleton() {
        nativeAdView.isHidden = true
        skeletonView.isHidden = false
    }
    
    func deactivate() {
        nativeAdView.nativeAd = nil
        headlineLabel.text = nil
        bodyLabel.text = nil
        iconImageView.image = nil
        mediaView.mediaContent = nil
    }

}
