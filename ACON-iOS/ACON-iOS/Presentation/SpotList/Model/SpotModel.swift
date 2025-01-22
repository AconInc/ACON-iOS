//
//  SpotModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/12/25.
//

import UIKit

// MARK: - Spot

struct SpotModel: Equatable {
    
    let id: Int
    
    let imageURL: String
    
    let matchingRate: Int?
    
    let type: String
    
    let name: String
    
    let walkingTime: Int
    
}


//struct SpotListModel: Equatable {
//    
//    let spots: [SpotModel]
//    
//}


// MARK: - Dummy data (삭제 예정)

extension SpotModel {
    
    static let dummy: [SpotModel] = [
        SpotModel(
            id: 0,
            imageURL: "imgEx1",
            matchingRate: 100,
            type: "CAFE",
            name: "카페1",
            walkingTime: 5
        ),
        SpotModel(
            id: 1,
            imageURL: "imgEx2",
            matchingRate: 88,
            type: "CAFE",
            name: "카페2",
            walkingTime: 5
        ),
        SpotModel(
            id: 2,
            imageURL: "imgEx3",
            matchingRate: 5,
            type: "RESTAURANT",
            name: "햄버거 가게3",
            walkingTime: 5
        ),
        SpotModel(
            id: 3,
            imageURL: "imgEx4",
            matchingRate: 50,
            type: "CAFE",
            name: "OO카페4",
            walkingTime: 5
        ),
        SpotModel(
            id: 4,
            imageURL: "imgEx1",
            matchingRate: 98,
            type: "CAFE",
            name: "카페5",
            walkingTime: 5
        ),
        SpotModel(
            id: 5,
            imageURL: "imgEx2",
            matchingRate: 88,
            type: "CAFE",
            name: "카페6",
            walkingTime: 5
        )
    ]
    
}
