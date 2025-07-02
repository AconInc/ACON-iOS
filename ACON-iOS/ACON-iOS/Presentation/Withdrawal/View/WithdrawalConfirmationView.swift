//
//  WithdrawalConfirmationView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/17/25.
//

import UIKit

final class WithdrawalConfirmationView: GlassmorphismView {
    
    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    
    private let descriptionLabel = UILabel()
    
    let cancelButton = ACButton(style: GlassButton(borderGlassmorphismType: .buttonGlassDefault, buttonType: .line_22_b1SB), title: StringLiterals.WithdrawalConfirmation.cancelButtonTitle)

    let confirmButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_22_b1SB), title: StringLiterals.WithdrawalConfirmation.confirmButtonTitle)
    
    
    // MARK: - LifeCycle
    
    init() {
        super.init(.bottomSheetGlass)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setHandlerImageView()

        titleLabel.setLabel(text: StringLiterals.WithdrawalConfirmation.title,
                            style: .h4SB,
                            alignment: .center)
        
        descriptionLabel.setLabel(text: StringLiterals.WithdrawalConfirmation.description,
                                  style: .b1R,
                                  color: .gray300,
                                  alignment: .center)
        
        [cancelButton, confirmButton].forEach {
            $0.isUserInteractionEnabled = true
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        addSubviews(titleLabel,
                    descriptionLabel,
                    cancelButton,
                    confirmButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(57*ScreenUtils.heightRatio)
            $0.horizontalEdges.equalToSuperview().inset(39*ScreenUtils.widthRatio)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(93*ScreenUtils.heightRatio)
            $0.horizontalEdges.equalToSuperview().inset(39*ScreenUtils.widthRatio)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(219*ScreenUtils.heightRatio)
            $0.leading.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.width.equalTo(ScreenUtils.widthRatio*120)
            $0.height.equalTo(ScreenUtils.heightRatio*44)
        }
        
        confirmButton.snp.makeConstraints{
            $0.top.equalToSuperview().inset(219*ScreenUtils.heightRatio)
            $0.trailing.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.width.equalTo(ScreenUtils.widthRatio*200)
            $0.height.equalTo(ScreenUtils.heightRatio*44)
        }
    }

}
