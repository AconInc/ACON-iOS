//
//  BaseNetworkErrorView.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/20/25.
//

import UIKit

class BaseErrorView: BaseView {
    
    // MARK: - UI Properties
    
    private let errorImageView = UIImageView()
    
    private let descriptionLabel = UILabel()
    
    let confirmButton = UIButton()
    
    
    // MARK: - UI Setting Methods
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(
            errorImageView,
            descriptionLabel,
            confirmButton
        )
    }
    
    override func setLayout() {
        super.setLayout()
        
        errorImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-150)
            $0.size.equalTo(ScreenUtils.widthRatio*140)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(errorImageView.snp.bottom).offset(24)
            $0.centerX.equalTo(errorImageView)
        }
        
        confirmButton.snp.makeConstraints{
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
    }
    
}


// MARK: - Internal Methods

extension BaseErrorView {
    
    func setStyle(errorImage: UIImage = .icError1,
                  errorMessage: String?,
                  buttonTitle: String?) {
        errorImageView.do {
            $0.image = errorImage
            $0.contentMode = .scaleAspectFit
        }
        
        if let errorMessage = errorMessage {
            descriptionLabel.do {
                $0.isHidden = false
                $0.setLabel(text: errorMessage,
                            style: .s1,
                            color: .gray4)
            }
        } else {
            descriptionLabel.isHidden = true
        }
        
        if let buttonTitle = buttonTitle {
            confirmButton.do {
                var config = UIButton.Configuration.filled()
                config.attributedTitle = AttributedString(
                    buttonTitle.ACStyle(.h7)
                
                )
                
                config.baseBackgroundColor = .subOrg35
                config.baseForegroundColor = .acWhite
                config.background.strokeColor = .org1
                config.background.strokeWidth = 1
                config.background.cornerRadius = 6
                config.contentInsets = .init(top: 13, leading: 16, bottom: 13, trailing: 16)
                $0.configuration = config
                $0.isHidden = false
            }
        } else {
            confirmButton.isHidden = true
        }
        
    }
    
}
