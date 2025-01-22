//
//  GetSearchKeywordResponse.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/21/25.
//

import Foundation

struct GetSearchKeywordResponse: Codable {
    
    let spotList: [SearchKeyword]
    
}

struct SearchKeyword: Codable {
    
    let spotId: Int64
    
    let name: String
    
    let address: String
    
    let spotType: SpotCategoryType
    
}
