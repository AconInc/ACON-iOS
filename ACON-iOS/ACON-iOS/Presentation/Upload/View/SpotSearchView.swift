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
    
    var recentSpotStackView: UIStackView = UIStackView()

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
                         recentSpotStackView,
                         relatedSearchCollectionView,
                         emptyView)
        searchView.addSubviews(searchImageView,
                               searchTextField,
                               searchXButton)
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
        
        relatedSearchCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.height*150/780)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(ScreenUtils.width*320/360)
            $0.centerX.equalToSuperview()
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
        
        relatedSearchCollectionView.do {
            $0.backgroundColor = .gray9
            $0.isScrollEnabled = true
            // TODO: - 기획 측에 이거 질문
            $0.showsVerticalScrollIndicator = false
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
    }
    
}
