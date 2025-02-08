//
//  AuthManager.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/23/25.
//

import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    private init() {}
    
    var hasToken: Bool {
        get {
            UserDefaults.standard.string(forKey: StringLiterals.UserDefaults.accessToken) != nil
        }
        
        set {
            print("🥑🥑🥑 [set] hasToken: \(newValue)")
        }
    }
    
}
