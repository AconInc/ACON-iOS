//
//  PostSpotListResponse.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/22/25.
//

import Foundation

struct PostSpotListResponse: Decodable {

    let transportMode: String?

    let spotList: [SpotDTO]

}

struct SpotDTO: Decodable {

    let spotId: Int64

    let image: String?

    let name: String

    let acornCount: Int

    let tagList: [String]?

    let isOpen: Bool

    let closingTime: String

    let nextOpening: String

    let eta: Int

    let latitude: Double

    let longitude: Double

}
