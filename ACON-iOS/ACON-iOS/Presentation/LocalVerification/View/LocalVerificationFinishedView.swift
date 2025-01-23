//
//  LocalVerificationFinishedView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/15/25.
//

import UIKit

import SnapKit
import Then

final class LocalVerificationFinishedView: BaseView {

    // MARK: - UI Properties
    
    var titleLabel: UILabel = UILabel()
    
    private let explainationLabel: UILabel = UILabel()
    
    private let localAcornImageView: UIImageView = UIImageView()
    
    private let plainAcornImageView: UIImageView = UIImageView()
    
    private let localAcornLabel: UILabel = UILabel()
    
    private let plainAcornLabel: UILabel = UILabel()
    
    var startButton: UIButton = UIButton()
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(titleLabel,
                         explainationLabel,
                         localAcornImageView,
                         plainAcornImageView,
                         localAcornLabel,
                         plainAcornLabel,
                         startButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*78)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*16)
        }
        
        explainationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*148)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*16)
        }
        
        localAcornImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*240)
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*60)
            $0.width.height.equalTo(104)
        }
        
        plainAcornImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*240)
            $0.trailing.equalToSuperview().inset(ScreenUtils.widthRatio*60)
            $0.width.height.equalTo(104)
        }
        
        localAcornLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*352)
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*60)
            $0.width.equalTo(104)
        }
        
        plainAcornLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*352)
            $0.trailing.equalToSuperview().inset(ScreenUtils.widthRatio*60)
            $0.width.equalTo(104)
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*40)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*16)
            $0.height.equalTo(52)
        }
        
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setHandlerImageView()
        self.backgroundColor = .dimB60
        self.backgroundColor?.withAlphaComponent(0.8)
        
        explainationLabel.do {
            $0.setLabel(text:  StringLiterals.LocalVerification.localAcornExplaination,
                        style: .b2,
                        color: .gray3)
        }
        
        localAcornImageView.do {
            $0.image = .localAcorn
            $0.contentMode = .scaleAspectFit
        }
        
        plainAcornImageView.do {
            $0.image = .plainAcorn
            $0.contentMode = .scaleAspectFit
        }
        
        localAcornLabel.do {
            $0.setLabel(text: StringLiterals.LocalVerification.localAcorn,
                        style: .h7,
                        color: .acWhite,
                        alignment: .center)
        }
        
        plainAcornLabel.do {
            $0.setLabel(text: StringLiterals.LocalVerification.plainAcorn,
                        style: .h7,
                        color: .acWhite,
                        alignment: .center)
        }
        
        startButton.do {
            $0.setAttributedTitle(text: StringLiterals.LocalVerification.letsStart,
                                   style: .h7,
                                  color: .gray6,
                                  for: .disabled)
            $0.setAttributedTitle(text: StringLiterals.LocalVerification.letsStart,
                                   style: .h7,
                                  color: .acWhite,
                                  for: .normal)
            $0.backgroundColor = .gray8
            $0.layer.cornerRadius = 6
        }
    }
    
}
