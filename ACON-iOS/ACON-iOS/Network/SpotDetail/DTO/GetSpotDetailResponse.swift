//
//  GetSpotDetailResponse.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/21/25.
//

import Foundation

struct GetSpotDetailResponse: Decodable {
    
    let id: Int64
    
    let imageList: [String]
    
    let name: String
    
    let acornCount: Int
    
    let hasMenuboardImage: Bool
    
    let signatureMenuList: [SignatureMenuDTO]?
    
    let latitude: Double
    
    let longitude: Double
    
}


struct SignatureMenuDTO: Decodable {

    let name: String

    let price: Int

}
