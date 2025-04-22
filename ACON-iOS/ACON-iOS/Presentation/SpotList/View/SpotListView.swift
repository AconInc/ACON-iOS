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
    
    lazy var floatingFilterButton = FloatingButton(image: .icFilterW)
    
    lazy var floatingMapButton = FloatingButton(image: .icMapW)
    
    lazy var floatingLocationButton = FloatingButton(image: .icMyGLocation)
    
    private let noAcornImageView = UIImageView()
    
    private let noAcornLabel = UILabel()
    
    private let skeletonView = SkeletonView()
    
    let errorView = BaseErrorView()
    
    
    // MARK: - UI Property Sizes
    
    private let floatingButtonSize: CGFloat = 44
    
    
    // MARK: - LifeCycles
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(
            collectionView,
            skeletonView,
            errorView,
            floatingButtonStack)
        
        floatingButtonStack.addArrangedSubviews(floatingLocationButton,
                                                floatingMapButton,
                                                floatingFilterButton)
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
        
        skeletonView.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(self.safeAreaLayoutGuide)
        }
        
        errorView.snp.makeConstraints {
            $0.edges.equalTo(collectionView)
        }
        
        // TODO: 추후 삭제 (Sprint-2 출시를 위한 히든처리)
        [floatingMapButton, floatingLocationButton].forEach {
            $0.isHidden = true
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        setCollectionView()
        setFloatingButtonStack()
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
            $0.backgroundColor = .gray900
            $0.setCollectionViewLayout(flowLayout, animated: true)
        }
    }
    
    func setFloatingButtonStack() {
        floatingButtonStack.do {
            $0.axis = .vertical
            $0.spacing = 8
        }
    }
    
}


// MARK: - Binding

extension SpotListView {
    
    func updateFilterButtonColor(_ isFilterSet: Bool) {
        isFilterSet
        ? floatingFilterButton.updateImage(.icFilterOrg)
        : floatingFilterButton.updateImage(.icFilterW)
    }
    
    func hideSkeletonView(isHidden: Bool) {
        skeletonView.isHidden = isHidden
    }
    
}
