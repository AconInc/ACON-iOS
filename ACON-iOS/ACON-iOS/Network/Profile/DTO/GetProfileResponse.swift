//
//  GetProfileResponse.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/15/25.
//

import Foundation

struct GetProfileResponse: Decodable {
    
    let image: String
    
    let nickname: String
    
    let leftAcornCount: Int
    
    let birthDate: String?
    
    let verifiedAreaList: [VerifiedArea]
    
}

struct VerifiedArea: Decodable {
    
    let id: Int64
    
    let name: String
    
}
