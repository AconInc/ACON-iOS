//
//  SpotSearchView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import UIKit

import SnapKit
import Then

final class SpotSearchView: GlassmorphismView {

    // MARK: - UI Properties
    
    private let spotUploadLabel: UILabel = UILabel()

    var searchTextField = ACTextField(icon: .icSearch24, borderColor: .gray500)

    var searchSuggestionScrollView: UIScrollView = UIScrollView()

    var searchSuggestionStackView: UIStackView = UIStackView()

    var searchKeywordCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: relatedSearchCollectionViewFlowLayout)

    let emptyView: UIView = UIView()

    private let emptyImageView: UIImageView = UIImageView()

    private let emptyLabel: UILabel = UILabel()


    // MARK: - Properties
    
    static var relatedSearchCollectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.itemSize = CGSize(width: ScreenUtils.widthRatio*320, height: ScreenUtils.heightRatio*52)
    }
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(spotUploadLabel,
                         searchTextField,
                         searchSuggestionScrollView,
                         searchKeywordCollectionView,
                         emptyView)
        searchSuggestionScrollView.addSubview(searchSuggestionStackView)
        emptyView.addSubviews(emptyImageView, emptyLabel)
    }
    
    override func setLayout() {
        super.setLayout()

        spotUploadLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*19)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(24)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*86)
            $0.height.equalTo(54)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.widthRatio*320)
        }
        
        searchSuggestionScrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*158)
            $0.height.equalTo(ScreenUtils.heightRatio*28)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(ScreenUtils.widthRatio*340)
        }
        
        searchKeywordCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*150)
            $0.height.equalTo(ScreenUtils.heightRatio*630 - safeAreaInsets.bottom)
            $0.width.equalTo(ScreenUtils.widthRatio*320)
            $0.centerX.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtils.heightRatio*200)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.widthRatio*146)
            $0.height.equalTo(ScreenUtils.heightRatio*116)
        }
        
        searchSuggestionStackView.snp.makeConstraints {
            $0.edges.equalTo(searchSuggestionScrollView.contentLayoutGuide)
            $0.height.equalTo(searchSuggestionScrollView.frameLayoutGuide.snp.height)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setGlassColor(.glaW10)
        
        self.setHandlerImageView()
        
        spotUploadLabel.do {
            $0.setLabel(text: StringLiterals.Upload.spotUpload2,
                        style: .h8,
                        color: .acWhite,
                        alignment: .center)
        }
        
        searchTextField.do {
            $0.setPlaceholder(as: StringLiterals.Upload.searchSpot)
        }
        
        searchSuggestionScrollView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.showsHorizontalScrollIndicator = false
        }
        
        searchSuggestionStackView.do {
            $0.spacing = 8
            $0.distribution = .fill
            $0.alignment = .center
        }
        
        searchKeywordCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = true
            $0.isHidden = true
            // TODO: - 기획 측에 이거 질문
            $0.showsVerticalScrollIndicator = false
        }
    }
    
}


// MARK: - Make RecommendedSpotButton

extension SpotSearchView {
    
    func makeRecommendedSpotButton(_ data: SearchSuggestionModel) -> UIButton {
        let button = UIButton()
        let recommendedSpotButtonConfiguration: UIButton.Configuration = {
            var configuration = UIButton.Configuration.plain()
            configuration.titleAlignment = .center
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 4,
                                                                  leading: 12,
                                                                  bottom: 4,
                                                                  trailing: 12)
            return configuration
        }()
        button.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        button.do {
            $0.backgroundColor = .gray800
            $0.layer.cornerRadius = 14
            $0.configuration = recommendedSpotButtonConfiguration
            $0.setAttributedTitle(text: data.spotName,
                                  style: .b2,
                                  color: .acWhite)
            $0.titleLabel?.numberOfLines = 1
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.spotID = data.spotId
        }
        return button
    }
    
}


// MARK: - Make RecommendedSpotButton

extension SpotSearchView {
    
    func bindData(_ data: [SearchSuggestionModel]) {
        searchSuggestionStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        if data.count != 0 {
            for i in 0...(data.count-1) {
                let button = makeRecommendedSpotButton(data[i])
                searchSuggestionStackView.addArrangedSubview(button)
            }
        }
    }
    
}
