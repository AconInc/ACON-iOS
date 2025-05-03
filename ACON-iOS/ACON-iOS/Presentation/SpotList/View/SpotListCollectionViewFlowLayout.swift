//
//  SpotListCollectionViewFlowLayout.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/1/25.
//

import UIKit

class SpotListCollectionViewFlowLayout: UICollectionViewFlowLayout {

    private let maxCellSize = CGSize(width: SpotListItemSizeType.itemMaxWidth.value,
                                     height: SpotListItemSizeType.itemMaxHeight.value)
    private let minCellSize  = CGSize(width: SpotListItemSizeType.itemMinWidth.value,
                                      height: SpotListItemSizeType.itemMinHeight.value)

    // NOTE: 셀이 센터에서 멀어질수록 작고 흐려지게 합니다.
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect)?.map({ $0.copy() }) as? [UICollectionViewLayoutAttributes],
              let collectionView = collectionView else {
            return nil
        }

        let centerY: CGFloat = collectionView.contentOffset.y + (collectionView.bounds.height / 2)

        for attribute in attributes {
            if attribute.representedElementCategory == .cell {
                let distanceFromCenter = abs(attribute.center.y - centerY)
                let transitionDistance: CGFloat = maxCellSize.height / 2
                let ratio = min(distanceFromCenter / transitionDistance, 1.0)
                let currentWidth = maxCellSize.width - (maxCellSize.width - minCellSize.width) * ratio
                let scale = currentWidth / maxCellSize.width
                
                attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
                attribute.alpha = 1.0 - (0.2 * ratio)
            }
        }

        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}
