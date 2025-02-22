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
    
    let condition: SpotCondition
    
}

struct SpotCondition: Encodable {
    
    let spotType: String?
    
    let filterList: [SpotFilter]?
    
    let walkingTime: Int?
    
    let priceRange: Int?
    
    enum CodingKeys: CodingKey {
        case spotType, filterList, walkingTime, priceRange
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.spotType, forKey: .spotType)
        try container.encodeIfPresent(self.filterList, forKey: .filterList)
        try container.encodeIfPresent(self.walkingTime, forKey: .walkingTime)
        try container.encodeIfPresent(self.priceRange, forKey: .priceRange)
    }
    
}

struct SpotFilter: Encodable {
    
    let category: String
    
    let optionList: [String]
    
}
