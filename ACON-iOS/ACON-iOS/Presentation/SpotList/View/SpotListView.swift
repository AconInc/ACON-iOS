//
//  SpotListView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/12/25.
//

import UIKit

import SkeletonView

class SpotListView: BaseView {

    // MARK: - UI Properties

    private let walkingFlowLayout = SpotListCollectionViewFlowLayout()
    private let bikingFlowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: NoMatchingSpotListItemSizeType.itemWidth.value,
                             height: NoMatchingSpotListItemSizeType.itemHeight.value)
        $0.minimumLineSpacing = NoMatchingSpotListItemSizeType.minimumLineSpacing.value
    }

    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: walkingFlowLayout
    )

    let regionErrorView = RegionErrorView()


    // MARK: - LifeCycles

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(
            collectionView,
            regionErrorView)
    }

    override func setLayout() {
        super.setLayout()

        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(-ScreenUtils.navViewHeight)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }

        regionErrorView.snp.makeConstraints {
            $0.edges.equalTo(collectionView)
        }
    }

    override func setStyle() {
        super.setStyle()

        self.isSkeletonable = true

        collectionView.do {
            $0.backgroundColor = .clear
            $0.decelerationRate = .fast
            $0.isSkeletonable = true
        }

        regionErrorView.isHidden = true
        
    }

}


// MARK: - Internal Methods

extension SpotListView {

    func updateCollectionViewLayout(type: TransportModeType?) {
        if type == .walking {
            collectionView.do {
                $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.bounds.height/2 - SpotListItemSizeType.itemMaxHeight.value/2, right: 0)
                $0.setCollectionViewLayout(walkingFlowLayout, animated: false)
            }
        } else {
            collectionView.do {
                $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                $0.setCollectionViewLayout(bikingFlowLayout, animated: false)
            }
        }
    }

}
