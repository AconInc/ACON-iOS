//
//  SpotListView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/12/25.
//

import UIKit

class SpotListView: BaseView {
    
    // MARK: - UI Properties
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private let floatingButtonStack = UIStackView()
    
    lazy var floatingFilterButton = FloatingButton(image: .icFilterW28)
    
    lazy var floatingMapButton = FloatingButton(image: .icMapW28)
    
    lazy var floatingLocationButton = FloatingButton(image: .icMyGLocation28)
    
    private let noAcornView = UIView()
    
    private let noAcornImageView = UIImageView()
    
    private let noAcornLabel = UILabel()
    
    
    // MARK: - UI Property Sizes
    
    private let floatingButtonSize: CGFloat = 44
    
    
    // MARK: - LifeCycles
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(
            collectionView,
            noAcornView,
            floatingButtonStack)
        
        floatingButtonStack.addArrangedSubviews(floatingLocationButton,
                                                floatingMapButton,
                                                floatingFilterButton)
        
        noAcornView.addSubviews(
            noAcornImageView,
            noAcornLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(-ScreenUtils.navViewHeight)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        floatingButtonStack.snp.makeConstraints {
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
        
        noAcornView.snp.makeConstraints {
            $0.edges.equalTo(collectionView)
        }
        
        noAcornImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(ScreenUtils.heightRatio * 180)
            $0.size.equalTo(ScreenUtils.widthRatio * 140)
        }
        
        noAcornLabel.snp.makeConstraints {
            $0.top.equalTo(noAcornImageView.snp.bottom).offset(24)
            $0.centerX.equalTo(noAcornImageView)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        setCollectionView()
        setFloatingButtonStack()
        setNoAcornView()
    }
    
}


// MARK: - UI Settings

private extension SpotListView {

    func setCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        // NOTE: itemSize는 Controller에서 설정합니다. (indexPath에 따라 다르기 때문)
        flowLayout.minimumLineSpacing = SpotListItemSizeType.minimumLineSpacing.value
        flowLayout.scrollDirection = .vertical
        
        collectionView.do {
            $0.backgroundColor = .gray9
            $0.setCollectionViewLayout(flowLayout, animated: true)
        }
    }
    
    func setFloatingButtonStack() {
        floatingButtonStack.do {
            $0.axis = .vertical
            $0.spacing = 8
        }
    }
    
    func setNoAcornView() {
        noAcornView.do {
            $0.backgroundColor = .gray9
            $0.isHidden = true
        }
        
        noAcornImageView.image = .imgEmptySearch
        
        noAcornLabel.setLabel(
            text: StringLiterals.SpotList.noAcorn,
            style: .s1,
            color: .gray4)
    }
    
}


// MARK: - Binding

extension SpotListView {
    
    func hideNoAcornView(isHidden: Bool) {
        noAcornView.isHidden = isHidden
    }
    
    func updateFilterButtonColor(_ isFilterSet: Bool) {
        isFilterSet
        ? floatingFilterButton.updateImage(.icFilterOrg28)
        : floatingFilterButton.updateImage(.icFilterW28)
    }
}
