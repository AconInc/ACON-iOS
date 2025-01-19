//
//  TestResponse.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import Foundation


struct TestResponse: Codable {
    
    let menuList: [MenuInfo]
    
}

struct MenuInfo: Codable {
    
    let id: Int64
    
    let name: String
    
    let price: Int
    
    let image: String
    
}
