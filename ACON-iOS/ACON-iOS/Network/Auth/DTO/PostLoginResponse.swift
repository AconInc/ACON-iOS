//
//  PostLoginResponse.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/22/25.
//

import Foundation

struct PostLoginResponse: Codable {
    
    let accessToken: String
    
    let refreshToken: String
    
    let hasVerifiedArea: Bool
    
}
