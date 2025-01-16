//
//  LocalVerificationView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import UIKit

import SnapKit
import Then

final class LocalVerificationView: BaseView {

    // MARK: - UI Properties
    
    private let weNeedYourAddressLabel: UILabel = UILabel()
    
    private let doLocalVerificationLabel: UILabel = UILabel()
    
    var verifyNewLocalButton: UIButton = UIButton()
    
    var nextButton: UIButton = UIButton()
    
    var verifyNewLocalButtonConfiguration: UIButton.Configuration = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8
        configuration.titleAlignment = .leading
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 16,
                                                              leading: 16,
                                                              bottom: 16,
                                                              trailing: 139)
        return configuration
    }()

    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(weNeedYourAddressLabel,
                         doLocalVerificationLabel,
                         verifyNewLocalButton,
                         nextButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        weNeedYourAddressLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*32/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(56)
        }
        
        doLocalVerificationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*96/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(18)
        }
        
        verifyNewLocalButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*146/780)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(ScreenUtils.height*52/780)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*36/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(52)
        }
        
    }
    
    override func setStyle() {
        super.setStyle()
        
        weNeedYourAddressLabel.do {
            $0.setLabel(text: StringLiterals.LocalVerification.needLocalVerification,
                        style: .h6,
                        color: .acWhite)
        }
        
        doLocalVerificationLabel.do {
            $0.setLabel(text:  StringLiterals.LocalVerification.doLocalVerification,
                        style: .b3,
                        color: .gray3)
        }
        
        verifyNewLocalButton.do {
            $0.configuration = verifyNewLocalButtonConfiguration
            $0.backgroundColor = .gray9
            $0.roundedButton(cornerRadius: 4, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(resource: .gray8).cgColor
            $0.setImage(.icRadio, for: .normal)
            $0.setImage(.icRadioSelected, for: .selected)
            $0.setPartialTitle(fullText: StringLiterals.LocalVerification.new + StringLiterals.LocalVerification.verifyLocal,
                               textStyles: [(StringLiterals.LocalVerification.new, .s2, .org1), (StringLiterals.LocalVerification.verifyLocal, .s2, .acWhite)])
        }
        
        nextButton.do {
            $0.setAttributedTitle(text: StringLiterals.LocalVerification.next,
                                   style: .h8,
                                  color: .gray6,
                                  for: .disabled)
            $0.setAttributedTitle(text: StringLiterals.LocalVerification.next,
                                   style: .h8,
                                  color: .acWhite,
                                  for: .normal)
            $0.backgroundColor = .gray8
            $0.roundedButton(cornerRadius: 6, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
        }
    }
    
}

