//
//  WithdrawalConfirmationView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/17/25.
//

import UIKit

import SnapKit
import Then

final class WithdrawalConfirmationView: GlassmorphismView {
    
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let cancelButton = UIButton(type: .system)
    let confirmButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setHandlerImageView()
        
        iconImageView.do {
            $0.image = .icError1
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.setLabel(text: StringLiterals.WithdrawalConfirmation.title,
                        style: .h5,
                        color: .acWhite,
                        alignment: .left,
                        numberOfLines: 0)
        }
        
        descriptionLabel.do {
            $0.setLabel(text: StringLiterals.WithdrawalConfirmation.description,
                        style: .s1,
                        color: .gray3,
                        alignment: .left,
                        numberOfLines: 2)
        }
        
        cancelButton.do {
            $0.backgroundColor = .gray5
            $0.setAttributedTitle(text: StringLiterals.WithdrawalConfirmation.cancelButtonTitle, style: .h7)
            $0.layer.cornerRadius = 6
        }
        
        confirmButton.do {
            $0.backgroundColor = .primaryDefault
            $0.setAttributedTitle(text: StringLiterals.WithdrawalConfirmation.confirmButtonTitle, style: .h7)
            $0.layer.cornerRadius = 6
        }
        
        closeButton.do {
            $0.setImage(.icX, for: .normal)
            $0.tintColor = .acWhite
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        addSubviews(iconImageView,
                    titleLabel,
                    descriptionLabel,
                    cancelButton,
                    confirmButton,
                    closeButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(28)
        }
        
        cancelButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(42)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(ScreenUtils.widthRatio*102)
            $0.height.equalTo(ScreenUtils.heightRatio*52)
            
        }
        
        confirmButton.snp.makeConstraints{
            $0.top.equalTo(cancelButton.snp.top)
            $0.leading.equalTo(cancelButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(ScreenUtils.widthRatio*214)
            $0.height.equalTo(ScreenUtils.heightRatio*52)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(cancelButton.snp.top).offset(-42)
            $0.leading.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(descriptionLabel.snp.top).offset(-8)
            $0.leading.equalToSuperview().inset(16)
        }
        
        iconImageView.snp.makeConstraints {
            $0.bottom.equalTo(titleLabel.snp.top).offset(-32)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(ScreenUtils.widthRatio*140)
        }
    }
    
}
