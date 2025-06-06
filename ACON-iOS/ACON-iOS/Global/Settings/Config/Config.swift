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
            
            static let nMapClientKey = "NMFClientId"
            
            static let nmfNcpKeyID = "NMFNcpKeyId"
            
            static let amplitudeKey = "AMPLITUDE_KEY"
            
            static let nmfCustomStyleID = "NMFCustomStyleID"
            
            static let GADApplicationIdentifier = "GADApplicationIdentifier"
            
            static let GADAdUnitIDImageOnly = "GAD_AD_UNIT_ID_IMAGE_ONLY"
            
            static let GADAdUnitID = "GAD_AD_UNIT_ID"
            
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
    
    static let nMapClientKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.nMapClientKey] as? String else {
            fatalError("nMapClientKey is not set in plist for this configuration")
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
        guard let key = Config.infoDictionary[Keys.Plist.amplitudeKey] as? String else {
            fatalError("amplitudeKey is not set in plist for this configuration")
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
    
    
}
