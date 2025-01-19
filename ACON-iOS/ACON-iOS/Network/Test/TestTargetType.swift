//
//  TestTargetType.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import Foundation

import Moya

enum TestTargetType {
    
    case getMenuList(spotID: Int)
    
}

extension TestTargetType: TargetType {

    var method: Moya.Method {
        switch self {
        case .getMenuList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getMenuList(let spotID):
            return utilPath + "spot/\(spotID)/menus"
        }
    }

    var parameter: [String : Any]? {
        switch self {
//        NOTE: 파라미터 있으면 이렇게 처리
//        case .getMenuInfo(let id):
//            return ["id" : id]
        default:
            return .none
        }
    }
    
    var task: Task {
        return .requestPlain
        // NOTE: 파라미터 있으면 이렇게 처리
//        if let parameter = parameter {
//            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
//        } else {
//            return .requestPlain
//        }
    }
    
    var headers: [String : String]? {
        // NOTE: header type 볼 것
        // NOTE: accessToken은 다음과 같이 부르면 됨 -> 현재 토큰 설정을 안 해서 오류 뜨는 게 당연함!!!!!!!!
        //        let token = UserDefaults.standard.string(forKey: StringLiterals.Network.accessToken) ?? ""
        //        let headers = HeaderType.headerWithToken(token: "Bearer " + token)
        let headers = HeaderType.noHeader
        return headers
    }
    
}
