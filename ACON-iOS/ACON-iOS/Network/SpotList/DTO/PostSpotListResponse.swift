//
//  PostSpotListResponse.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/22/25.
//

import Foundation

struct PostSpotListResponse: Codable {

    let spotList: [Spot]

}

struct Spot: Codable {
    
    let id: Int
    let image: String
    let matchingRate: Int
    let type: String
    let name: String
    let walkingTime: Int
    
}
