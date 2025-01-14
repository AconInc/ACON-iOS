//
//  LocalMapView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/15/25.
//

import UIKit

import SnapKit
import Then

final class LocalMapView: BaseView {

    // MARK: - UI Properties
    
    let localMapImageView: UIImageView = UIImageView()
    
    var finishVerificationButton: UIButton = UIButton()

    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(localMapImageView,
                         finishVerificationButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        localMapImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.height*564/780)
        }
        
        finishVerificationButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*36/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(52)
        }
        
    }
    
    override func setStyle() {
        super.setStyle()
        
        localMapImageView.do {
            $0.backgroundColor = .gray
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

