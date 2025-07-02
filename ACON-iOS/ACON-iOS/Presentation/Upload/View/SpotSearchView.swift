//
//  SpotSearchView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import UIKit

final class SpotSearchView: BaseView {

    // MARK: - UI Properties

    var searchTextField = ACTextField(icon: .icSearch,
                                      borderWidth: 0,
                                      cornerRadius: 10,
                                      doneButton: false,
                                      backgroundGlassType: .textfieldGlass)

    lazy var searchSuggestionCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: searchSuggestionCollectionViewFlowLayout)

    var glassView = GlassmorphismView(.backgroundGlass)
    
    lazy var searchKeywordCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: searchKeywordCollectionViewFlowLayout)

    let searchEmptyView: SearchEmptyView = SearchEmptyView()
    
    
    // MARK: - Properties
    
    let searchSuggestionCollectionViewFlowLayout: UICollectionViewFlowLayout = LeftAlignedCollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumInteritemSpacing = 8
        $0.minimumLineSpacing = 8
        $0.sectionInset = UIEdgeInsets(top: 10, left: ScreenUtils.horizontalInset, bottom: 10, right: ScreenUtils.horizontalInset)
        $0.estimatedItemSize = CGSize(width: 100, height: 38)
    }
    
   let searchKeywordCollectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.itemSize = CGSize(width: ScreenUtils.widthRatio*328, height: ScreenUtils.heightRatio*72)
    }
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(searchTextField,
                         searchSuggestionCollectionView,
                         glassView)
        
        glassView.addSubviews(searchKeywordCollectionView, searchEmptyView)
        
    }
    
    override func setLayout() {
        super.setLayout()
        
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(ScreenUtils.heightRatio*38)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.horizontalInset)
        }
        
        searchSuggestionCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*54)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(ScreenUtils.heightRatio*300)
        }
        
        glassView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtils.heightRatio*48)
            $0.height.equalTo(ScreenUtils.heightRatio*300)
            $0.width.equalTo(ScreenUtils.widthRatio*328)
            $0.centerX.equalToSuperview()
        }
        
        searchKeywordCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        searchEmptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        searchTextField.do {
            $0.setPlaceholder(as: StringLiterals.Upload.searchSpot)
            $0.hideClearButton(isHidden: true)
        }
        
        searchSuggestionCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
        }
        
        glassView.do {
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
            $0.isHidden = true
        }
        
        searchKeywordCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = true
        }
        
        searchEmptyView.do {
            $0.isHidden = true
        }
    }
    
}
