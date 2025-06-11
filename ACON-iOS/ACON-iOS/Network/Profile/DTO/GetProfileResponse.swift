//
//  GetProfileResponse.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/15/25.
//

import Foundation

struct GetProfileResponse: Decodable {
    
    let profileImage: String
    
    let nickname: String
    
    let leftAcornCount: Int
    
    let birthDate: String?
    
    let savedSpotList: [SavedSpotDTO]
    
}

struct VerifiedAreaDTO: Decodable {
    
    let verifiedAreaId: Int64
    
    let name: String
    
}
