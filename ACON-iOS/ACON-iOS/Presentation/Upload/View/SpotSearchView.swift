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
    
    let searchView: UIView = UIView()
    
    var searchTextField: UITextField = UITextField()
    
    let searchImageView: UIImageView = UIImageView()
    
    let searchXButton: UIButton = UIButton()
    
    var doneButton: UIButton = UIButton()
    
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
                         searchView,
                         doneButton,
                         searchSuggestionScrollView,
                         searchKeywordCollectionView,
                         emptyView)
        searchView.addSubviews(searchImageView,
                               searchTextField,
                               searchXButton)
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
        
        searchView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*86)
            $0.height.equalTo(54)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.widthRatio*320)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*19)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(40)
            $0.height.equalTo(24)
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
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*200)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.widthRatio*146)
            $0.height.equalTo(ScreenUtils.heightRatio*116)
        }
        
        searchImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(ScreenUtils.widthRatio*44)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(ScreenUtils.widthRatio*232)
            $0.height.equalTo(20)
        }
        
        searchXButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(ScreenUtils.widthRatio*6)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        searchSuggestionStackView.snp.makeConstraints {
            $0.edges.equalTo(searchSuggestionScrollView.contentLayoutGuide)
            $0.height.equalTo(searchSuggestionScrollView.frameLayoutGuide.snp.height)
        }
        
        emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
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
        
        searchView.do {
            $0.backgroundColor = .gray8
            $0.roundCorners(cornerRadius: 4, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(resource: .gray6).cgColor
        }
        
        doneButton.do {
            $0.isEnabled = false
            $0.setAttributedTitle(text: StringLiterals.Upload.done,
                                  style: .b2,
                                  color: .gray5,
                                  for: .disabled)
            $0.setAttributedTitle(text: StringLiterals.Upload.done,
                                  style: .b2,
                                  color: .acWhite,
                                  for: .normal)
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
        
        emptyView.do {
            $0.isHidden = true
        }
        
        searchImageView.do {
            $0.image = .icSearch24
            $0.contentMode = .scaleAspectFit
        }
        
        searchTextField.do {
            $0.attributedPlaceholder = StringLiterals.Upload.searchSpot.ACStyle(.b2, .gray5)
            $0.defaultTextAttributes = [
                .font: ACFontStyleType.b2.font,
                .kern: ACFontStyleType.b2.kerning,
                .paragraphStyle: {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.minimumLineHeight = ACFontStyleType.b2.lineHeight
                    paragraphStyle.maximumLineHeight = ACFontStyleType.b2.lineHeight
                    return paragraphStyle
                }(),
                .foregroundColor: UIColor.acWhite,
                .baselineOffset: (ACFontStyleType.b2.lineHeight - ACFontStyleType.b2.font.lineHeight) / 2
            ]
        }
        
        searchXButton.do {
            $0.setImage(.icDissmissCircleGray, for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
        }
        
        emptyImageView.do {
            $0.image = .imgEmptySearch
            $0.contentMode = .scaleAspectFit
        }
        
        emptyLabel.do {
            $0.setLabel(text: StringLiterals.Upload.noMatchingSpots,
                        style: .b2,
                        color: .gray4,
                        alignment: .center)
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
            $0.backgroundColor = .gray8
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
