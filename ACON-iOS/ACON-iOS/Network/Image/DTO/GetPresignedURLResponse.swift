//
//  GetPresignedURLResponse.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/17/25.
//

import Foundation

struct GetPresignedURLResponse: Decodable {
    
    let fileName: String
    
    let preSignedURL: String
    
}
