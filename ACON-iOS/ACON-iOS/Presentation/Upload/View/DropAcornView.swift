//
//  DropAcornView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/13/25.
//

import UIKit

import SnapKit
import Then

final class DropAcornView: BaseView {

    // MARK: - UI Properties
    
    private let dropAcornLabel: UILabel = UILabel()
    
    private let useAcornToReviewLabel: UILabel = UILabel()
    
    var acornNumberLabel: UILabel = UILabel()
    
    var acornStackView: UIView = UIView()
    
    private let acornReviewLabel: UILabel = UILabel()
    
    var leaveReviewButton: UIButton = UIButton()
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(dropAcornLabel,
                         useAcornToReviewLabel,
                         acornNumberLabel,
                         acornStackView,
                         acornReviewLabel,
                         leaveReviewButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        dropAcornLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*32/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(56)
        }
        
        useAcornToReviewLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*96/780)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(18)
        }
        
        acornNumberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*122/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(18)
        }
        
        acornStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*172/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*76/360)
            $0.height.equalTo(ScreenUtils.height*40/780)
        }
        
        acornReviewLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*146/780)
            $0.height.equalTo(18)
        }
        
        leaveReviewButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*36/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(52)
        }
        
    }
    
    override func setStyle() {
        super.setStyle()
        
        dropAcornLabel.do {
            $0.setLabel(text: StringLiterals.Upload.shallWeDropAcorns,
                        style: .h6,
                        color: .acWhite)
        }
        
        useAcornToReviewLabel.do {
            $0.setLabel(text: StringLiterals.Upload.useAcornToReview,
                        style: .b3,
                        color: .gray3)
        }
        
        acornNumberLabel.do {
            $0.setLabel(text: StringLiterals.Upload.acornsIHave,
                        style: .b4,
                        color: .gray5)
        }
        
//        acornStackView.do {
//            $0.addSubview(<#T##view: UIView##UIView#>)
//            
//        }
        
        acornReviewLabel.do {
            $0.setLabel(text: "1/5",
                        style: .b4,
                        color: .gray3)
        }
        
        leaveReviewButton.do {
            $0.setAttributedTitle(text: StringLiterals.Upload.reviewWithAcornsHere,
                                   style: .h8,
                                  color: .gray6,
                                  for: .disabled)
            $0.setAttributedTitle(text: StringLiterals.Upload.dropAcornsHere,
                                   style: .h8,
                                  color: .acWhite,
                                  for: .normal)
            // TODO: - enable 시 backgroundcolor main_org1
            $0.backgroundColor = .gray8
            $0.roundedButton(cornerRadius: 6, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
        }
    }
    
    
}

