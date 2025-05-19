//
//  CustomAlertView.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/20/25.
//

import UIKit

final class CustomAlertView: BaseView {
    
    // MARK: - UI Properties
    
    private let alertContainerView = GlassmorphismView(.alertGlass)
    
    private let titleLabel = UILabel()
    
    private let descriptionLabel = UILabel()

    private let horizontalLineView: UIView = UIView()
    
    let longButton = UIButton()
    
    private let verticalLineView: UIView = UIView()
    
    let leftButton = UIButton()
    
    let rightButton = UIButton()
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubview(alertContainerView)
        alertContainerView.addSubviews(titleLabel,
                                       descriptionLabel,
                                       horizontalLineView,
                                       longButton,
                                       leftButton,
                                       verticalLineView,
                                       rightButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        alertContainerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(ScreenUtils.widthRatio * 270)
            $0.height.greaterThanOrEqualTo(ScreenUtils.heightRatio * 114)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*24)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio * 16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(ScreenUtils.heightRatio * 8)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio * 16)
        }
        
        horizontalLineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(ScreenUtils.heightRatio * 20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        longButton.snp.makeConstraints {
            $0.top.equalTo(horizontalLineView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.heightRatio * 43)
        }
        
        leftButton.snp.makeConstraints {
            $0.top.equalTo(horizontalLineView.snp.bottom)
            $0.leading.bottom.equalToSuperview()
            $0.width.equalTo((ScreenUtils.widthRatio * 270 - 1)/2)
            $0.height.equalTo(ScreenUtils.heightRatio * 43)
        }
        
        verticalLineView.snp.makeConstraints {
            $0.top.equalTo(horizontalLineView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.heightRatio * 43)
            $0.width.equalTo(1)
        }
        
        rightButton.snp.makeConstraints {
            $0.top.equalTo(horizontalLineView.snp.bottom)
            $0.trailing.bottom.equalToSuperview()
            $0.width.equalTo((ScreenUtils.widthRatio * 270 - 1)/2)
            $0.height.equalTo(ScreenUtils.heightRatio * 43)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.backgroundColor = .dimDefault
        
        alertContainerView.do {
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
        }
        
        [horizontalLineView, verticalLineView].forEach {
            $0.backgroundColor = .gray100.withAlphaComponent(0.2)
        }
        
        [descriptionLabel,
         longButton,
         leftButton,
         rightButton,
         verticalLineView].forEach {
            $0.isHidden = true
        }
    }
    
}


// MARK: - Configuration

extension CustomAlertView {
    
    func configure(title: String,
                   description: String?,
                   longButtonTitle: String?,
                   leftButtonTitle: String?,
                   rightButtonTitle: String?,
                   isDangerButton: Bool = false) {
        
        titleLabel.setLabel(text: title,
                            style: .t4SB,
                            alignment: .center,
                            numberOfLines: 0)
        
        if let description = description {
            descriptionLabel.isHidden = false
            
            descriptionLabel.setLabel(text: description,
                                      style: .b1R,
                                      color: .gray200,
                                      alignment: .center,
                                      numberOfLines: 0)
            
            horizontalLineView.snp.remakeConstraints {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(ScreenUtils.heightRatio * 20)
                $0.horizontalEdges.equalToSuperview()
                $0.height.equalTo(1)
            }
        }
        
        if let longButtonTitle = longButtonTitle {
            longButton.isHidden = false
            
            longButton.setAttributedTitle(text: longButtonTitle,
                                          style: .t4SB,
                                          color: .labelAction)
        }
        
        if let leftButtonTitle = leftButtonTitle,
           let rightButtonTitle = rightButtonTitle {
            
            [leftButton, rightButton, verticalLineView].forEach { $0.isHidden = false }
            
            leftButton.setAttributedTitle(text: leftButtonTitle,
                                          style: .t4R,
                                          color: isDangerButton ? .labelAction : .acWhite)
            
            rightButton.setAttributedTitle(text: rightButtonTitle,
                                          style: .t4SB,
                                           color: isDangerButton ? .labelDanger : .labelAction)
        }
        
        self.alertContainerView.setNeedsUpdateConstraints()
        self.alertContainerView.updateConstraintsIfNeeded()
    }
    
}
