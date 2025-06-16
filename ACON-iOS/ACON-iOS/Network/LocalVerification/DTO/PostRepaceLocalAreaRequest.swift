//
//  PostRepaceLocalAreaRequest.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/12/25.
//

import Foundation

struct PostReplaceVerifiedAreaRequest: Codable {
    
    let previousVerifiedAreaId: Int64
    
    let latitude: Double
    
    let longitude: Double
    
}
