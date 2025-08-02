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
            
            static let nmfNcpKeyID = "NMFNcpKeyId"
            
            static let amplitudeKeyDebug = "AMPLITUDE_KEY_DEBUG"
            
            static let amplitudeKeyRelease = "AMPLITUDE_KEY_RELEASE"
            
            static let nmfCustomStyleID = "NMFCustomStyleID"
            
            static let GADApplicationIdentifier = "GADApplicationIdentifier"
            
            static let GADAdUnitIDImageOnly = "GAD_AD_UNIT_ID_IMAGE_ONLY"
            
            static let GADAdUnitID = "GAD_AD_UNIT_ID"
            
            static let basicProfileImage = "BASIC_PROFILE_IMAGE"
            
            static let naverAPIClientID = "NAVER_API_CLIENT_ID"
            
            static let naverAPIClientSecret = "NAVER_API_CLIENT_SECRET"
            
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
    
    static let nmfNcpKeyID: String = {
        guard let key = Config.infoDictionary[Keys.Plist.nmfNcpKeyID] as? String else {
            fatalError("nmfNcpKeyID is not set in plist for this configuration")
        }
        return key
    }()
    
    static let amplitudeKey: String = {
    #if DEBUG
        let keyName = Keys.Plist.amplitudeKeyDebug
    #else
        let keyName = Bundle.main.isTestFlight
            ? Keys.Plist.amplitudeKeyDebug
            : Keys.Plist.amplitudeKeyRelease
    #endif

        guard let key = Config.infoDictionary[keyName] as? String else {
            fatalError("Amplitude key '\(keyName)' is not set in plist for this configuration")
        }
        return key
    }()
    
    static let nmfCustomStyleID: String = {
        guard let key = Config.infoDictionary[Keys.Plist.nmfCustomStyleID] as? String else {
            fatalError("nmfCustomStyleID is not set in plist for this configuration")
        }
        return key
    }()
    
    static let GADApplicationIdentifier: String = {
        guard let key = Config.infoDictionary[Keys.Plist.GADApplicationIdentifier] as? String else {
            fatalError("GADApplicationIdentifier is not set in plist for this configuration")
        }
        return key
    }()
    
    static let GADAdUnitID: String = {
        guard let key = Config.infoDictionary[Keys.Plist.GADAdUnitID] as? String else {
            fatalError("GADAddUnitID is not set in plist for this configuration")
        }
        return key
    }()
    
    static let GADAdUnitIDImageOnly: String = {
        guard let key = Config.infoDictionary[Keys.Plist.GADAdUnitIDImageOnly] as? String else {
            fatalError("GADAddUnitIDImageOnly is not set in plist for this configuration")
        }
        return key
    }()
    
    static let basicProfileImage: String = {
        guard let key = Config.infoDictionary[Keys.Plist.basicProfileImage] as? String else {
            fatalError("basicProfileImage is not set in plist for this configuration")
        }
        return key
    }()
    
    static let naverAPIClientID: String = {
        guard let key = Config.infoDictionary[Keys.Plist.naverAPIClientID] as? String else {
            fatalError("naverAPIClientID is not set in plist for this configuration")
        }
        return key
    }()
    
    static let naverAPIClientSecret: String = {
        guard let key = Config.infoDictionary[Keys.Plist.naverAPIClientSecret] as? String else {
            fatalError("naverAPIClientSecret is not set in plist for this configuration")
        }
        return key
    }()
    
    
}
