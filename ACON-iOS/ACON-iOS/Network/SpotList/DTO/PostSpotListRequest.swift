//
//  SpotListDTO.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/21/25.
//

import Foundation

struct PostSpotListRequest: Codable {
    
    let latitude: Double
    
    let longitude: Double
    
    let condition: SpotCondition
    
}

struct SpotCondition: Codable {
    
    let spotType: String
    
    let filterList: [SpotFilter] // TODO: Optional로 수정
    
    let walkingTime: Int
    
    let priceRange: Int
    
}

struct SpotFilter: Codable {
    
    let category: String
    
    let optionList: [String]
    
}
