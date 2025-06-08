//
//  SavedSpotView.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/8/25.
//

import UIKit

final class SavedSpotView: BaseView {

    // MARK: - UI Properties
    
    private let skeletonView: UIView = UIView()
    
    private let gradientView: UIView = UIView()
    
    private let spotImageView: UIImageView = UIImageView()
    
    private let spotNameLabel: UILabel = UILabel()
    
    private let preparingImageLabel: UILabel = UILabel()

    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(skeletonView,
                         spotImageView,
                         gradientView,
                         spotNameLabel,
                         preparingImageLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        skeletonView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(4)
        }
        
        spotImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        spotNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*12)
            $0.horizontalEdges.equalToSuperview().inset(20*ScreenUtils.widthRatio)
            $0.height.equalTo(20)
        }
        
        preparingImageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }

        spotImageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        
        preparingImageLabel.do {
            $0.isHidden = true
            $0.setLabel(text: "이미지 준비중", style: .c1R)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.gradientView.setGradient(
                bottomColor: .gray900.withAlphaComponent(0)
            )
        }
    }
}


// MARK: - Bind Data

extension SavedSpotView {
    
    func bindData(_ data: SavedSpotModel) {
        skeletonView.isHidden = false
        preparingImageLabel.isHidden = true
        
        spotNameLabel.setLabel(text: data.name.abbreviatedStringWithException(9), style: .t5SB)
        
        if let imageURL = data.image {
            spotImageView.kf.setImage(
                with: URL(string: imageURL),
                options: [.transition(.none), .cacheOriginalImage]
            ) { [weak self] result in
                DispatchQueue.main.async {
                    self?.preparingImageLabel.isHidden = true
                    self?.skeletonView.isHidden = true
                }
            }
        } else {
            spotImageView.image = .imgSpotNoImageBackground
            preparingImageLabel.isHidden = false
            skeletonView.isHidden = true
        }
    }
    
}


// MARK: - Helper

extension SavedSpotView {
    
    func cleanView() {
        self.do {
            $0.spotImageView.kf.cancelDownloadTask()
            $0.spotImageView.image = nil
            $0.skeletonView.isHidden = false
            $0.preparingImageLabel.isHidden = true
            $0.spotNameLabel.text = nil
        }
    }
    
}
