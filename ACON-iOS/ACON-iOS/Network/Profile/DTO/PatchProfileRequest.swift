//
//  PatchProfileRequest.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/19/25.
//

import Foundation

struct PatchProfileRequest: Encodable {
    
    let profileImage: String
    
    let nickname: String
    
    let birthDate: String?
    
}
