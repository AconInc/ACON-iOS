//
//  GetSpotMenuResponse.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/21/25.
//

import Foundation

struct GetSpotMenuResponse: Codable {
    
    let menuList: [SpotMenuInfo]
    
}

struct SpotMenuInfo: Codable {
    
    let id: Int64
    
    let name: String
    
    let price: Int
    
    let image: String?
    
}
