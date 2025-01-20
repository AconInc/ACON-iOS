//
//  SpotReviewView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/13/25.
//

import UIKit

import SnapKit
import Then

final class SpotUploadView: BaseView {

    // MARK: - UI Properties
    
    private let spotUploadLabel: UILabel = UILabel()
    
    var spotSearchButton : UIButton = UIButton()
    
    var dropAcornButton: UIButton = UIButton()
    
    var spotSearchButtonConfiguration: UIButton.Configuration = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .leading
        configuration.imagePadding = 12
        configuration.titleAlignment = .leading
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 24)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 14,
                                                              leading: 12,
                                                              bottom: 14,
                                                              trailing: 194)
        return configuration
    }()
    

    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(spotUploadLabel,
                         spotSearchButton,
                         dropAcornButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        spotUploadLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*32/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(24)
            $0.width.equalTo(58)
        }
        
        spotSearchButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*64/780)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(ScreenUtils.height*52/780)
        }
        
        dropAcornButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.height*40/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*16/360)
            $0.height.equalTo(ScreenUtils.height*52/780)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        spotUploadLabel.do {
            $0.setLabel(text: StringLiterals.Upload.spotUpload,
                        style: .h8,
                        color: .acWhite)
        }
        
        spotSearchButton.do {
            $0.configuration = spotSearchButtonConfiguration
            $0.backgroundColor = .gray8
            $0.roundedButton(cornerRadius: 4, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(resource: .gray7).cgColor
            $0.setImage(.icLocation, for: .normal)
            $0.setAttributedTitle(text: StringLiterals.Upload.uploadSpotName,
                                  style: .s2,
                                  color: .gray5)
            
        }
        
        dropAcornButton.do {
            $0.setAttributedTitle(text: StringLiterals.Upload.dropAcornsHere,
                                   style: .h8,
                                  color: .acWhite,
                                  for: .normal)
            $0.setAttributedTitle(text: StringLiterals.Upload.dropAcornsHere,
                                   style: .h8,
                                  color: .gray6,
                                  for: .disabled)
            // TODO: - enable 시 backgroundcolor gray5
            $0.backgroundColor = .gray8
            $0.roundedButton(cornerRadius: 6, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
        }
    }
    
    
}

