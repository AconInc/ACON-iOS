//
//  AppTargetType.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/20/25.
//

import Foundation

import Moya

enum AppTargetType {

    case getAppUpdate(_ parameter: GetAppUpdateRequest)
    
}

extension AppTargetType: TargetType {

    var method: Moya.Method {
        switch self {
        case .getAppUpdate:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getAppUpdate:
            return utilPath + "app-updates"
        }
    }
    
    var parameter: [String : Any]?  {
        switch self {
        case .getAppUpdate(let parameter):
            return ["platform": parameter.platform, "version": parameter.version]
        }
    }
    
    var task: Task {
        switch self {
        default:
            if let parameter = parameter {
                return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
            } else {
                return .requestPlain
            }
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getAppUpdate:
            return HeaderType.noHeader
        }
    }
        
    
}
