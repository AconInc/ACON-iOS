//
//  GetVerifiedAreaListResponse.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/19/25.
//

import Foundation

struct GetVerifiedAreaListResponse: Decodable {
    
    let verifiedAreaList: [VerifiedAreaDTO]
    
}

struct VerifiedAreaDTO: Decodable {
    
    let verifiedAreaId: Int64
    
    let name: String
    
}

