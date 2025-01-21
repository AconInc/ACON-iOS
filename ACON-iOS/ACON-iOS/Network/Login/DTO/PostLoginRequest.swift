//
//  PostGoogleLoginRequest.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/22/25.
//

import Foundation

struct PostLoginRequest: Codable {
    
    let socialType: String
    
    let idToken: String
    
}
