//
//  SpotListGoogleAdCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/4/25.
//

import UIKit
import GoogleMobileAds

class SpotListGoogleAdCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Properties
    
//    private var adContentView: NativeAdContentView?
    
    private var adContentView: ProfileGoogleAdView?
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        deactivate()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if let adContentView = adContentView {
            print("🔍 광고 셀 layoutSubviews 호출")
        }
    }
}


// MARK: - Public Methods

extension SpotListGoogleAdCollectionViewCell {
    
    func activate(with nativeAd: NativeAd) {
        deactivate()

        let newAdContentView = ProfileGoogleAdView()
        adContentView = newAdContentView
        
        contentView.addSubview(newAdContentView)
        newAdContentView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(140)
//            $0.edges.equalToSuperview()
        }
        
        newAdContentView.configure(with: nativeAd)
        
        print("✅ 광고 셀 활성화")
    }
    
    /// 광고 비활성화 (중앙에서 벗어날 때)
    func deactivate() {
        if adContentView != nil {
            print("✅ 광고 셀 비활성화")
        }
        
        adContentView?.removeFromSuperview()
        adContentView = nil
    }
    

    func showSkeleton() {
        if adContentView == nil {
            let newAdContentView = ProfileGoogleAdView()
            adContentView = newAdContentView
            
            contentView.addSubview(newAdContentView)
            newAdContentView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.horizontalEdges.equalToSuperview()
                $0.height.equalTo(140)
//                $0.edges.equalToSuperview()
            }
        }
        
        adContentView?.showSkeleton()
    }
    
    var isActivated: Bool {
        return adContentView != nil
    }
    
}
