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
    
    var acornStackView: UIStackView = UIStackView()
    
    var acornReviewLabel: UILabel = UILabel()
    
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
            $0.centerX.equalToSuperview()
            $0.width.equalTo(208)
            $0.height.equalTo(40)
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
        
        acornStackView.do {
            for _ in 0...4 {
                let acornImageView = makeAcornImageButton()
                $0.addArrangedSubview(acornImageView)
            }
            $0.spacing = 2
            $0.axis = .horizontal
        }
        
        acornReviewLabel.do {
            $0.setLabel(text: "0/5",
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
            $0.backgroundColor = .gray8
            $0.roundedButton(cornerRadius: 6, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
        }
    }
    
}

extension DropAcornView {
    
    func makeAcornImageButton() -> UIButton {
        let button = UIButton()
        button.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
        button.do {
            $0.setImage(.icGReview, for: .normal)
            $0.setImage(.icWReview, for: .selected)
            $0.contentMode = .scaleAspectFit
        }
        return button
    }
    
}
