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
    
    var spotSearchButton: UIButton = UIButton()
    
    var spotSearchButtonConfiguration: UIButton.Configuration = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .leading
        configuration.imagePadding = 4
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 24)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 14,
                                                              leading: ScreenUtils.widthRatio * 12,
                                                              bottom: 14,
                                                              trailing: ScreenUtils.widthRatio * 308 - 24)
        return configuration
    }()
    
    var spotNameLabel: UILabel = UILabel()
    

    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(spotUploadLabel,
                         spotSearchButton,
                         spotNameLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        spotUploadLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*32)
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*20)
            $0.height.equalTo(24)
            $0.width.equalTo(58)
        }
        
        spotSearchButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*64)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*20)
            $0.height.equalTo(ScreenUtils.heightRatio*52)
        }
        
        spotNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(spotSearchButton.snp.centerY)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*32 + 24 + 4)
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
            $0.backgroundColor = .gray800
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(resource: .gray700).cgColor
            $0.setImage(.icLocationGray, for: .normal)
        }
        
        spotNameLabel.do {
            $0.setLabel(text: StringLiterals.Upload.searchSpot,
                        style: .s2,
                        color: .gray500)
        }
        
    }
    
}

