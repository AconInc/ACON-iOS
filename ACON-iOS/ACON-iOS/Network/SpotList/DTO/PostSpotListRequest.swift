//
//  SpotListDTO.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/21/25.
//

import Foundation

struct PostSpotListRequest: Encodable {

    let latitude: Double

    let longitude: Double

    let condition: SpotConditionDTO

}

struct SpotConditionDTO: Encodable {

    let spotType: String

    let filterList: [SpotFilterDTO]?

    enum CodingKeys: CodingKey {
        case spotType, filterList, walkingTime, priceRange
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.spotType, forKey: .spotType)
        try container.encodeIfPresent(self.filterList, forKey: .filterList)
    }

}

struct SpotFilterDTO: Encodable {

    let category: String

    let optionList: [String]

}
