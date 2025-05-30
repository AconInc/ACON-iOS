//
//  SpotListView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/12/25.
//

import UIKit

class SpotListView: BaseView {

    // MARK: - UI Properties

    let walkingFlowLayout = SpotListCollectionViewFlowLayout()
    let bikingFlowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: NoMatchingSpotListItemSizeType.itemWidth.value,
                             height: NoMatchingSpotListItemSizeType.itemHeight.value)
        $0.minimumLineSpacing = NoMatchingSpotListItemSizeType.minimumLineSpacing.value
    }

    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    private let skeletonView = SkeletonView()

    let errorView = TempSpotListErrorView(.imageTitleButton) // TODO: 수정


    // MARK: - LifeCycles

    override func setHierarchy() {
        super.setHierarchy()

        self.addSubviews(
            collectionView,
            skeletonView,
            errorView)
    }

    override func setLayout() {
        super.setLayout()

        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(-ScreenUtils.navViewHeight)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }

        skeletonView.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(self.safeAreaLayoutGuide)
        }

        errorView.snp.makeConstraints {
            $0.edges.equalTo(collectionView)
        }
    }

    override func setStyle() {
        super.setStyle()

        setCollectionView()
        // TODO: 배경 블러
    }

}


// MARK: - UI Settings

private extension SpotListView {

    func setCollectionView() {
        collectionView.do {
            $0.backgroundColor = .clear
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: SpotListItemSizeType.itemMaxHeight.value/2 - self.bounds.height/2, right: 0)
            $0.decelerationRate = .fast
        }
    }

}


// MARK: - Internal Methods

extension SpotListView {

    func hideSkeletonView(isHidden: Bool) {
        skeletonView.isHidden = isHidden
    }

    func updateCollectionViewLayout(type: TransportModeType?) {
        if type == .walking {
            collectionView.do {
                $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: SpotListItemSizeType.itemMaxHeight.value/2 - self.bounds.height/2, right: 0)
                $0.setCollectionViewLayout(walkingFlowLayout, animated: false)
                $0.decelerationRate = .fast
            }
        } else {
            collectionView.do {
                $0.backgroundColor = .clear
                $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                $0.setCollectionViewLayout(bikingFlowLayout, animated: false)
                $0.decelerationRate = .fast
            }
        }
    }
}
