//
//  GetAppUpdateRequest.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/20/25.
//

import Foundation

struct GetAppUpdateRequest: Codable {
    
    let platform: String = "ios"
    
    let version: String
    
}
