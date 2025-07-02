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
    
    let birthDate: String?
    
    let savedSpotList: [SavedSpotDTO]
    
}
