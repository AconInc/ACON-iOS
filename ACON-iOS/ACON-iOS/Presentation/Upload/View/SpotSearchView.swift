//
//  SpotSearchView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import UIKit

import SnapKit
import Then

final class SpotSearchView: BaseView {

    // MARK: - UI Properties
    
    private let handlerImageView: UIImageView = UIImageView()
    
    private let spotUploadLabel: UILabel = UILabel()
    
    let searchView: UIView = UIView()
    
    var searchTextField: UITextField = UITextField()
    
    let searchImageView: UIImageView = UIImageView()
    
    let searchXButton: UIButton = UIButton()
    
    var doneButton: UIButton = UIButton()
    
    var recommendedSpotScrollView: UIScrollView = UIScrollView()
    
    var recommendedSpotStackView: UIStackView = UIStackView()

    var relatedSearchCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: relatedSearchCollectionViewFlowLayout)
    
    let emptyView: UIView = UIView()

    let emptyImageView: UIImageView = UIImageView()

    let emptyLabel: UILabel = UILabel()

    
    // MARK: - Properties
    
    static var relatedSearchCollectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.itemSize = CGSize(width: ScreenUtils.width*320/360, height: ScreenUtils.height*52/780)
    }
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(handlerImageView,
                         spotUploadLabel,
                         searchView,
                         doneButton,
                         recommendedSpotScrollView,
                         relatedSearchCollectionView,
                         emptyView)
        searchView.addSubviews(searchImageView,
                               searchTextField,
                               searchXButton)
        recommendedSpotScrollView.addSubview(recommendedSpotStackView)
        emptyView.addSubviews(emptyImageView, emptyLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        handlerImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*4/780)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.height*64/780)
            $0.height.equalTo(ScreenUtils.height*3/780)
        }
        
        spotUploadLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*19/780)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(24)
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*86/780)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.height.equalTo(54)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*19/780)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(40)
            $0.height.equalTo(24)
        }
        
        recommendedSpotScrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*150/780)
            $0.height.equalTo(ScreenUtils.height*28/780)
            $0.leading.equalToSuperview().inset(ScreenUtils.width*20/360)
            $0.trailing.equalToSuperview()
        }
        
        relatedSearchCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*150/780)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(ScreenUtils.width*320/360)
            $0.centerX.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*200/780)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.width*146/360)
            $0.height.equalTo(ScreenUtils.height*116/780)
        }
        
        searchImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(ScreenUtils.width*16/360)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(ScreenUtils.width*44/360)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(ScreenUtils.width*232/360)
            $0.height.equalTo(20)
        }
        
        searchXButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(ScreenUtils.width*6/360)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        recommendedSpotStackView.snp.makeConstraints {
            $0.edges.equalTo(recommendedSpotScrollView.contentLayoutGuide)
            $0.height.equalTo(recommendedSpotScrollView.frameLayoutGuide.snp.height)
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
        
        handlerImageView.do {
            $0.image = .btnBottomsheetBar
            $0.contentMode = .scaleAspectFit
        }
        
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
            $0.setAttributedTitle(text: StringLiterals.Upload.done,
                                  style: .b2,
                                  color: .gray5,
                                  for: .normal)
        }
        
        recommendedSpotScrollView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.showsHorizontalScrollIndicator = false
        }
        
        recommendedSpotStackView.do {
            $0.spacing = 8
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .center
        }
        
        relatedSearchCollectionView.do {
            $0.backgroundColor = .gray9
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
    
    func makeRecommendedSpotButton(_ title: String) -> UIButton {
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
            $0.setAttributedTitle(text: title,
                                  style: .b2,
                                  color: .acWhite)
            $0.titleLabel?.numberOfLines = 1
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        return button
    }
    
}
