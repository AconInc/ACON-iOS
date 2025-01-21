//
//  LoginService.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/22/25.
//

import Foundation

import Moya

protocol LoginServiceProtocol {
    
    func postLogin(_ requestBody: PostLoginRequest,
                   completion: @escaping (NetworkResult<PostLoginResponse>) -> Void)

    
}

final class LoginService: BaseService<LoginTargetType>, LoginServiceProtocol {
    
    func postLogin(_ requestBody: PostLoginRequest, completion: @escaping (NetworkResult<PostLoginResponse>) -> Void) {
        self.provider.request(.postLogin(requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PostLoginResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: PostLoginResponse.self)
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }
    
}
