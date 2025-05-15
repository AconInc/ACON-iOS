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

    var searchTextField = ACTextField(icon: .icSearch, borderColor: .gray500)

    lazy var searchSuggestionCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: searchSuggestionCollectionViewFlowLayout)

    lazy var searchKeywordCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: searchKeywordCollectionViewFlowLayout)

    let emptyView: UIView = UIView()

    private let emptyImageView: UIImageView = UIImageView()

    private let emptyLabel: UILabel = UILabel()


    // MARK: - Properties
    
    let searchSuggestionCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.do {
            $0.scrollDirection = .vertical
            $0.minimumInteritemSpacing = 8
            $0.minimumLineSpacing = 8
            $0.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            $0.estimatedItemSize = CGSize(width: 100, height: 38)
        }
        return layout
    }()
    
   let searchKeywordCollectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.itemSize = CGSize(width: ScreenUtils.widthRatio*320, height: ScreenUtils.heightRatio*52)
    }
    
    
    // MARK: - Lifecycle
    
    init() {
        // 🍇 TODO: 글모 Type 확인
        super.init(.bottomSheetGlass)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(spotUploadLabel,
                         searchTextField,
                         searchSuggestionCollectionView,
                         searchKeywordCollectionView,
                         emptyView)
        
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
        
        searchSuggestionCollectionView.snp.makeConstraints {
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
    }
    
    override func setStyle() {
        super.setStyle()
        
        searchTextField.do {
            $0.setPlaceholder(as: StringLiterals.Upload.searchSpot)
        }
        
        searchSuggestionCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
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
