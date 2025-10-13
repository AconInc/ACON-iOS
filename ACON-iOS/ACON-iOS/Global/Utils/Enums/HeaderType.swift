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
    
    static func imageHeader(contentType: String) -> [String: String] {
        return ["Content-Type" : contentType]
    }
    
    static func headerWithToken() -> [String: String] {
        if let token = UserDefaultsUtils.get(String.self, forKey: .accessToken) {
            return ["Content-Type" : "application/json", "Authorization" : "Bearer " + token]
        } else {
            return basicHeader
        }
    }
    
    static func tokenOnly() -> [String:String] {
        if let token = UserDefaultsUtils.get(String.self, forKey: .accessToken) {
            return ["Authorization" : "Bearer " + token]
        } else {
            return noHeader
        }
    }
    
}
