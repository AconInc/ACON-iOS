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
    
    static func imageHeader(imageData: Data) -> [String: String] {
        return ["Content-Type" : "image/jpeg", "Content-Length": "\(imageData.count)" ]
    }
    
    static func headerWithToken() -> [String: String] {
        if let token = UserDefaults.standard.string(forKey: StringLiterals.UserDefaults.accessToken) {
            return ["Content-Type" : "application/json", "Authorization" : "Bearer " + token]
        } else {
            return basicHeader
        }
    }
    
    static func tokenOnly() -> [String:String] {
        let token = UserDefaults.standard.string(forKey: StringLiterals.UserDefaults.accessToken) ?? ""
        return ["Authorization" : "Bearer " + token]
    }
    
}
