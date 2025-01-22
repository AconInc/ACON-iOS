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
    
    var finishVerificationButton: UIButton = UIButton()

    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(nMapView,
                         finishVerificationButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        nMapView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.heightRatio*564)
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
            $0.showLocationButton = true
            $0.showZoomControls = false
            $0.showScaleBar = false
            $0.showCompass = false
            $0.mapView.positionMode = .normal
            $0.mapView.zoomLevel = 17
            $0.mapView.minZoomLevel = 14
            $0.mapView.maxZoomLevel = 18
        }
        
        finishVerificationButton.do {
            $0.setAttributedTitle(text: StringLiterals.LocalVerification.finishVerification,
                                  style: .h8,
                                  color: .acWhite,
                                  for: .normal)
            $0.backgroundColor = .gray5
            $0.roundedButton(cornerRadius: 6, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
        }
    }
    
}

