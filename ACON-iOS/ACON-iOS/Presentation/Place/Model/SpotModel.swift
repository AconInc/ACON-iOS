//
//  SpotModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/12/25.
//

import UIKit

struct Spot {
    let image: UIImage?
    let matchingRate: Int
    let type: String
    let name: String
    let walkingTime: Int
}

struct Spots {
    let array: [Spot]
}

//extension SpotModel {
//    func splitData(spots: [SpotModel]) {
//        guard !spots.isEmpty else { return [] }
//
//            // 첫 번째 그룹은 첫 두 개의 아이템
//            let firstGroup = Array(spots.prefix(2))
//            // 나머지는 두 번째 그룹
//            let secondGroup = Array(spots.dropFirst(2))
//            
//            return [firstGroup, secondGroup]
//        }
//    }
//}

extension Spot {
    static let dummy: [Spot] = [
        Spot(
            image: .imgEx1,
            matchingRate: 98,
            type: "CAFE",
            name: "OO카페",
            walkingTime: 5
        ),
        Spot(
            image: .imgEx2,
            matchingRate: 88,
            type: "CAFE",
            name: "ㅁㅁ카페",
            walkingTime: 5
        ),
        Spot(
            image: .imgEx3,
            matchingRate: 80,
            type: "RESTAURANT",
            name: "햄버거 가게",
            walkingTime: 5
        ),
        Spot(
            image: .imgEx4,
            matchingRate: 50,
            type: "CAFE",
            name: "OO카페",
            walkingTime: 5
        )
    ]
}
