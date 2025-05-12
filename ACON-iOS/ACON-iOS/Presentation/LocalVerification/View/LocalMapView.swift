//
//  LocalMapView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/15/25.
//

import UIKit

import NMapsMap
import SnapKit
import Then

final class LocalMapView: BaseView {

    // MARK: - UI Properties
    
    let nMapView: NMFNaverMapView = NMFNaverMapView()
    
    var acMapMarker: NMFMarker = NMFMarker()
    
    var finishVerificationButton: ACButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault,
                                                                         buttonType: .full_12_t4SB),
                                                      title: StringLiterals.LocalVerification.finishVerification)
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(nMapView,
                         finishVerificationButton)
    }
    
    override func setLayout() {
        super.setLayout()

        nMapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        finishVerificationButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*36)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*20)
            $0.height.equalTo(52)
        }
        
    }
    
    override func setStyle() {
        super.setStyle()
        
        nMapView.do {
            $0.showLocationButton = false
            $0.showZoomControls = false
            $0.showScaleBar = false
            $0.showCompass = false
            $0.mapView.do {
                $0.positionMode = .disabled
                $0.zoomLevel = 17
                $0.minZoomLevel = 14
                $0.maxZoomLevel = 18
                $0.customStyleId = Config.nmfCustomStyleID
                $0.logoAlign = .rightTop
                $0.logoMargin = ConstraintInsets(top: ScreenUtils.topInsetHeight+ScreenUtils.heightRatio*80, left: 0, bottom: 0, right: ScreenUtils.widthRatio*16)
            }
        }

        acMapMarker.do {
            $0.iconImage = NMFOverlayImage(name: "ic_location")
            // TODO: 피그마상 36x36인데 우선 디자인과 100X100으로 합의
            $0.width = 100
            $0.height = 100
            $0.mapView = nMapView.mapView
        }
    }
    
}

