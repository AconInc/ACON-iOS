//
//  PostLogoutRequest.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/17/25.
//

import Foundation

struct PostLogoutRequest: Encodable {
    
    let refreshToken: String
    
}
