//
//  PostPresignedURLResponse.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/17/25.
//

import Foundation

struct PostPresignedURLResponse: Decodable {
    
    let fileUrl: String
    
    let preSignedUrl: String
    
}
