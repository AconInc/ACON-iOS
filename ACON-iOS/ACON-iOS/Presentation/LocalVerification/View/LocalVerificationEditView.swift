//
//  LocalVerificationEditView.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/17/25.
//

import UIKit

class LocalVerificationEditView: BaseView {

    // MARK: - Sizes
    
    private let horizontalInset: CGFloat = 20
    
    private let verticalSpacing: CGFloat = 12
    
    
    // MARK: - UI Properties
    
    private let verifiedAreaTitleLabel = UILabel()
    
    let verifiedAreaAddButton = UIButton()
    
    let verifiedAreaStackView = UIStackView()
    
    let verifiedAreaBox = LabelBoxWithDeletableButton()
    
    

    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(verifiedAreaTitleLabel,
                         verifiedAreaAddButton,
                         verifiedAreaStackView)
        
    }
    
    override func setLayout() {
        super.setLayout()
        
        verifiedAreaTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(horizontalInset)
        }
        
        verifiedAreaAddButton.snp.makeConstraints {
            $0.top.equalTo(verifiedAreaTitleLabel.snp.bottom).offset(verticalSpacing)
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
            $0.height.equalTo(48)
        }
        
        verifiedAreaStackView.snp.makeConstraints {
            $0.top.equalTo(verifiedAreaAddButton.snp.bottom).offset(verticalSpacing)
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
        }
        
    }
    
    override func setStyle() {
        super.setStyle()
        
        verifiedAreaTitleLabel.setPartialText(
            fullText: StringLiterals.Profile.verifiedArea + StringLiterals.Profile.neccessaryStarWithSpace,
            textStyles: [
                (text: StringLiterals.Profile.verifiedArea, style: .h8, color: .acWhite),
                (text: StringLiterals.Profile.neccessaryStarWithSpace, style: .h8, color: .org1)
            ]
        )
        
        verifiedAreaAddButton.do {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .init(top: 12, leading: 12, bottom: 12, trailing: 16)
            config.attributedTitle = AttributedString(StringLiterals.Profile.addVerifiedArea.ACStyle(.s1))
            config.image = .icAdd20
            config.imagePadding = 27
            config.imagePlacement = .trailing
            config.background.cornerRadius = 4
            config.background.strokeColor = .gray5
            config.background.strokeWidth = 1
            $0.configuration = config
        }
        
        verifiedAreaStackView.do {
            $0.axis = .vertical
        }
    }
    
}
