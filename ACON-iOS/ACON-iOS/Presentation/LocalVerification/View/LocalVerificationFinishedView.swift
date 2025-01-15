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
            $0.top.equalToSuperview().inset(ScreenUtils.height*32/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(56)
        }
        
        explainationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*96/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(36)
        }
        
        localAcornImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*258/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*73/360)
            $0.width.height.equalTo(80)
        }
        
        plainAcornImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*258/780)
            $0.trailing.equalToSuperview().inset(ScreenUtils.width*73/360)
            $0.width.height.equalTo(80)
        }
        
        localAcornLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*346/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*66/360)
            $0.width.equalTo(94)
        }
        
        plainAcornLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*346/780)
            $0.trailing.equalToSuperview().inset(ScreenUtils.width*66/360)
            $0.width.equalTo(94)
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*36/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
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
                        style: .b3,
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
                        style: .s1,
                        color: .acWhite,
                        alignment: .center)
        }
        
        plainAcornLabel.do {
            $0.setLabel(text: StringLiterals.LocalVerification.plainAcorn,
                        style: .s1,
                        color: .acWhite,
                        alignment: .center)
        }
        
        startButton.do {
            $0.setAttributedTitle(text: StringLiterals.LocalVerification.letsStart,
                                   style: .h8,
                                  color: .gray6,
                                  for: .disabled)
            $0.setAttributedTitle(text: StringLiterals.LocalVerification.letsStart,
                                   style: .h8,
                                  color: .acWhite,
                                  for: .normal)
            $0.backgroundColor = .gray8
            $0.roundedButton(cornerRadius: 6, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
        }
    }
    
}
