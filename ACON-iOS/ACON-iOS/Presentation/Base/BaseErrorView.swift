//
//  BaseNetworkErrorView.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/20/25.
//

import UIKit

class BaseErrorView: BaseView {
    
    // MARK: - Datas
    
    private let errorImage: UIImage
    
    private let errorMessage: String
    
    private let buttonTitle: String
    
    
    // MARK: - UI Properties
    
    private let errorImageView = UIImageView()
    
    private let descriptionLabel = UILabel()
    
    let confirmButton = UIButton()
    
    
    // MARK: - Initializer
    
    init(
        errorImage: UIImage = .icError1140,
        errorMessage: String,
        buttonTitle: String
    ) {
        self.errorImage = errorImage
        self.errorMessage = errorMessage
        self.buttonTitle = buttonText
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setting Methods
    
    override func setStyle() {
        super.setStyle()
        
        errorImageView.do {
            $0.image = errorImage
            $0.contentMode = .scaleAspectFit
        }
        
        descriptionLabel.do {
            $0.setLabel(text: errorMessage,
                        style: .s1,
                        color: .gray4)
        }
        
        confirmButton.do {
            var config = UIButton.Configuration.filled()
            config.attributedTitle = AttributedString(
                buttonTitle.ACStyle(.h7)
            
            )
            config.baseBackgroundColor = .org1
            config.background.cornerRadius = 6
            config.contentInsets = .init(top: 13, leading: 16, bottom: 13, trailing: 16)
            $0.configuration = config
        }
    }
    
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
            $0.top.equalToSuperview().offset(100 * ScreenUtils.heightRatio)
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
