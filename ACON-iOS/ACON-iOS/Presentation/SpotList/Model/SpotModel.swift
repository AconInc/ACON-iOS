//
//  SpotModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/12/25.
//

import UIKit

// MARK: - Spot

struct Spot: Equatable {
    
    let image: UIImage?
    let matchingRate: Int
    let type: String
    let name: String
    let walkingTime: Int
    
}


// MARK: - Spots

struct Spots {
    
    let array: [Spot]
    
}


// MARK: - CollectionView Layout

struct SpotListItemHeight {
    
    static func longItemHeight(_ collectionViewHeight: CGFloat) -> CGFloat {
        let shortHeight = shortItemHeight(collectionViewHeight)
        return collectionViewHeight - shortHeight - 12
    }
    
    static func shortItemHeight(_ collectionViewHeight: CGFloat) -> CGFloat {
        let lineSpacing = SpotListItemSizeType.minimumLineSpacing.value
        return (collectionViewHeight - lineSpacing * 3) / 4
    }
    
}


// MARK: - Dummy data (삭제 예정)

extension Spots {
    
    static let dummy: [Spot] = [
        Spot(
            image: .imgEx1,
            matchingRate: 98,
            type: "CAFE",
            name: "카페1",
            walkingTime: 5
        ),
        Spot(
            image: .imgEx2,
            matchingRate: 88,
            type: "CAFE",
            name: "카페2",
            walkingTime: 5
        ),
        Spot(
            image: .imgEx3,
            matchingRate: 80,
            type: "RESTAURANT",
            name: "햄버거 가게3",
            walkingTime: 5
        ),
        Spot(
            image: .imgEx4,
            matchingRate: 50,
            type: "CAFE",
            name: "OO카페4",
            walkingTime: 5
        ),
        Spot(
            image: .imgEx1,
            matchingRate: 98,
            type: "CAFE",
            name: "카페5",
            walkingTime: 5
        ),
        Spot(
            image: .imgEx2,
            matchingRate: 88,
            type: "CAFE",
            name: "카페6",
            walkingTime: 5
        )
    ]
    
}
