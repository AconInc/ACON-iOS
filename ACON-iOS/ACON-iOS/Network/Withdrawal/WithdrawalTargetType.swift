//
//  WithdrawalTargetType.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/18/25.
//

import Foundation

import Moya

enum WithdrawalTargetType {
    
    case postWithdrawal(requestBody: WithdrawalRequest)
    
}

extension WithdrawalTargetType: TargetType {
    
    var path: String {
        switch self {
        case .postWithdrawal:
            return utilPath + "members/withdrawal"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postWithdrawal:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .postWithdrawal(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .postWithdrawal:
            return HeaderType.headerWithToken()
        }
    }
    
}
