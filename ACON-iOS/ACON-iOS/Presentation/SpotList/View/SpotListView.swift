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

    private let noAcornImageView = UIImageView()

    private let noAcornLabel = UILabel()

    private let skeletonView = SkeletonView()

    let errorView = BaseErrorView()


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
        // TODO: 커스텀 토글
    }

}


// MARK: - UI Settings

private extension SpotListView {

    func setCollectionView() {
        let flowLayout = SpotListCollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: SpotListItemSizeType.itemMaxWidth.value,
                                     height: SpotListItemSizeType.itemMaxHeight.value)
        flowLayout.minimumLineSpacing = SpotListItemSizeType.minimumLineSpacing.value
        flowLayout.scrollDirection = .vertical

        collectionView.do {
            $0.backgroundColor = .clear
            $0.setCollectionViewLayout(flowLayout, animated: true)
            $0.decelerationRate = .fast
        }
    }

}


// MARK: - Internal Methods

extension SpotListView {

    func hideSkeletonView(isHidden: Bool) {
        skeletonView.isHidden = isHidden
    }

}
