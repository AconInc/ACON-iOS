//
//  NaverSearchTargetType.swift
//  ACON-iOS
//
//  Created by 이수민 on 8/1/25.
//

import Foundation

import Moya

enum NaverSearchTargetType {

    case getNaverSearch(_ parameter: GetNaverSearchRequest)
    
}

extension NaverSearchTargetType: TargetType {

    var baseURL: URL {
        return URL(string: "https://openapi.naver.com")!
    }
    
    var path: String {
        switch self {
        case .getNaverSearch:
            return "/v1/search/local.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getNaverSearch:
            return .get
        }
    }
    
    var parameter: [String : Any]?  {
        switch self {
        case .getNaverSearch(let parameter):
            return ["query": parameter.query, "display": parameter.display]
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
    
    var headers: [String: String]? {
        return [
            "X-Naver-Client-Id": Config.naverAPIClientID,
            "X-Naver-Client-Secret": Config.naverAPIClientSecret
        ]
    }
        
    
}
