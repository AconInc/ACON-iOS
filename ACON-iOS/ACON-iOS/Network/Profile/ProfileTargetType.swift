//
//  ProfileTargetType.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/15/25.
//

import Foundation

import Moya

enum ProfileTargetType {
    
    case getProfile

}

extension ProfileTargetType: TargetType {

    var method: Moya.Method {
        switch self {
        case .getProfile:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getProfile:
            return utilPath + "members/me"
        }
    }
    
    var parameter: [String : Any]?  {
        switch self {
        default:
            return .none
        }
    }

    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        switch self {
        case .getProfile:
            return HeaderType.tokenOnly()
        }
    }

}
