//
//  GetSavedSpotsResponse.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/8/25.
//

import Foundation

struct GetSavedSpotsResponse: Decodable {
    
    let savedSpotList: [SavedSpotDTO]
    
}

struct SavedSpotDTO: Decodable {
    
    let id: Int64
    
    let image: String?
    
    let name: String
    
}
