//
//  GetSpotDetailResponse.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/21/25.
//

import Foundation

struct GetSpotDetailResponse: Codable {
    
    let id: Int64
    
    let name: String
    
    let spotType: SpotCategoryType
    
    let imageList: [String]
    
    let openStatus: Bool
    
    let address: String

    let localAcornCount: Int
    
    let basicAcornCount: Int
    
    let latitude: Double
    
    let longitude: Double
    
}
