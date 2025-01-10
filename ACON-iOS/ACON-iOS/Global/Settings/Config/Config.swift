//
//  Config.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/9/25.
//

import Foundation

enum Config {
    
    enum Keys {
        
        enum Plist {
            
            static let baseURL = "BASE_URL"

            static let googleClientID = "GIDClientID"
            
            static let googleWebClientID = "GOOGLE_WEB_CLIENT_ID"
            
            static let nmapAPIKey = "NMAP_API_KEY"
            
        }
        
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found !!!")
        }
        return dict
    }()
    
}


extension Config {
    
    static let baseURL: String = {
        guard let key = Config.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("BASE_URL is not set in plist for this configuration")
        }
        return key
    }()
    
    static let googleClientID: String = {
        guard let key = Config.infoDictionary[Keys.Plist.googleClientID] as? String else {
            fatalError("GOOGLE_CLIENT_ID is not set in plist for this configuration")
        }
        return key
    }()
    
    static let googleWebClientID: String = {
        guard let key = Config.infoDictionary[Keys.Plist.googleWebClientID] as? String else {
            fatalError("GOOGLE_WEB_CLIENT_ID is not set in plist for this configuration")
        }
        return key
    }()
    
    static let nmapAPIKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.nmapAPIKey] as? String else {
            fatalError("nmapAPIKey is not set in plist for this configuration")
        }
        return key
    }()
    
}
