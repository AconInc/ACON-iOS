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
    
    static func headerWithToken() -> [String: String] {
        let token = UserDefaults.standard.string(forKey: StringLiterals.UserDefaults.accessToken) ?? ""
        return ["Content-Type" : "application/json", "Authorization" : "Bearer " + token]
    }
    
    static func tokenOnly() -> [String:String] {
        let token = UserDefaults.standard.string(forKey: StringLiterals.UserDefaults.accessToken) ?? ""
        return ["Authorization" : "Bearer " + token]
    }
    
}
