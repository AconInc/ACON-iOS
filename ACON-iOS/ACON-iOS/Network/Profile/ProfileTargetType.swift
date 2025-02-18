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
    
    case getNicknameValidity(_ parameter: GetNicknameValidityRequestQuery)

}

extension ProfileTargetType: TargetType {

    var method: Moya.Method {
        switch self {
        case .getProfile:
            return .get
        case .getNicknameValidity:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getProfile:
            return utilPath + "members/me"
        case .getNicknameValidity(_):
            return utilPath + "members/nickname/validate"
        }
    }
    
    var parameter: [String : Any]?  {
        switch self {
        case .getNicknameValidity(let parameter):
            return ["nickname": parameter.nickname]
        default:
            return .none
        }
    }

    var task: Task {
        switch self {
        case .getNicknameValidity:
            if let parameter = parameter {
                return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
            } else {
                return .requestPlain
            }
        default:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        switch self {
        case .getProfile:
            return HeaderType.tokenOnly()
        case .getNicknameValidity:
            return HeaderType.tokenOnly()
        }
    }

}
