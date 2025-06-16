//
//  GetSpotDetailResponse.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/21/25.
//

import Foundation

struct GetSpotDetailResponse: Decodable {
    
    let spotId: Int64
    
    let imageList: [String]?
    
    let name: String
    
    let acornCount: Int
    
    let tagList: [String]?
    
    let isOpen: Bool
    
    let closingTime: String
    
    let nextOpening: String
    
    let hasMenuboardImage: Bool
    
    let isSaved: Bool
    
    let signatureMenuList: [SignatureMenuDTO]?
    
    let latitude: Double
    
    let longitude: Double
    
}


struct SignatureMenuDTO: Decodable {

    let name: String

    let price: Int

}
