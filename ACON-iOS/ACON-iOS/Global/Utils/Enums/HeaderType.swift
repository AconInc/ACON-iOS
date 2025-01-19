//
//  HeaderType.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import Foundation

enum HeaderType {
    
    static let noHeader: [String:String] = [:]
    
    static let basicHeader = ["Content-Type" : "application/json"]
    
    static func headerWithToken(token: String) -> [String: String] {
        return ["Content-Type" : "application/json", "Authorization" : token]
    }
    
}
