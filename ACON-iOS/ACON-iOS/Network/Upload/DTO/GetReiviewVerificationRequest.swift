//
//  GetReviewVerificationRequest.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/21/25.
//

import Foundation

struct GetReviewVerificationRequest: Codable {
    
    let spotId: Int64
    
    let latitude: Double
    
    let longitude: Double
    
}
