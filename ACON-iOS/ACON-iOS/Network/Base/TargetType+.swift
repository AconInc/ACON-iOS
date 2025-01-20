//
//  TargetType+.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import Foundation

import Moya

extension TargetType {
    
    var baseURL: URL {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.baseURL) as? String,
              let url = URL(string: urlString) else {
            fatalError("💢💢 BASE_URL이 없음 💢💢")
        }
        return url
    }
    
    var utilPath: String {
        return "api/v1/"
    }
    
}
