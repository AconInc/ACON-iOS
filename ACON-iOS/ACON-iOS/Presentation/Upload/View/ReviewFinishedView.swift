//
//  ReviewFinishedView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/13/25.
//

import UIKit

import SnapKit
import Then

final class ReviewFinishedView: BaseView {

    // MARK: - UI Properties
    
    private let finishedReviewLabel: UILabel = UILabel()
    
    private let wishYouPreferenceLabel: UILabel = UILabel()
    
    private let finishedReviewImageView: UIImageView = UIImageView()
    
    private let closeViewLabel: UILabel = UILabel()
    
    var okButton: UIButton = UIButton()
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(finishedReviewLabel,
                         wishYouPreferenceLabel,
                         finishedReviewImageView,
                         closeViewLabel,
                         okButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        finishedReviewLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*40/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(56)
        }
        
        wishYouPreferenceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*104/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(18)
        }
        
        finishedReviewImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(ScreenUtils.height*162/780)
            $0.height.equalTo(246)
            $0.height.equalTo(320)
        }
        
        closeViewLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*100/780)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(18)
        }
        
        okButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*36/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(52)
        }
        
    }
    
    override func setStyle() {
        super.setStyle()
        
        finishedReviewLabel.do {
            $0.setLabel(text: StringLiterals.Upload.finishedReview,
                        style: .h6,
                        color: .acWhite)
        }
        
        wishYouPreferenceLabel.do {
            $0.setLabel(text: StringLiterals.Upload.wishYouPreference,
                        style: .b3,
                        color: .gray3)
        }
        
        finishedReviewImageView.do {
            $0.image = .imgUploadFinish
            $0.contentMode = .scaleAspectFit
        }
        
        closeViewLabel.do {
            $0.setLabel(text: StringLiterals.Upload.closeAfterFiveSeconds,
                        style: .b3,
                        color: .gray3)
        }
        
        okButton.do {
            $0.setAttributedTitle(text: StringLiterals.Upload.dropAcornsHere,
                                   style: .h8,
                                  color: .acWhite,
                                  for: .normal)
            $0.backgroundColor = .gray5
            $0.roundedButton(cornerRadius: 6, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
        }
    }
    
}
