//
//  GetNaverSearchRequest.swift
//  ACON-iOS
//
//  Created by 이수민 on 8/1/25.
//

import Foundation

struct GetNaverSearchRequest: Encodable {
    
    let query: String
    
    let display: Int = 5
    
}
