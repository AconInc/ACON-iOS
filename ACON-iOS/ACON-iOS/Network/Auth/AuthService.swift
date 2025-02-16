//
//  AuthService.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/22/25.
//

import Foundation

import Moya

protocol AuthServiceProtocol {
    
    func postLogin(_ requestBody: PostLoginRequest,
                   completion: @escaping (NetworkResult<PostLoginResponse>) -> Void)
    
    func postLogout(_ requestBody: PostLogoutRequest,
                    completion: @escaping (NetworkResult<EmptyResponse>) -> Void)
    
    func postReissue(_ requestBody: PostReissueRequest,
                     completion: @escaping (NetworkResult<PostReissueResponse>) -> Void)
    
}

final class AuthService: BaseService<AuthTargetType>, AuthServiceProtocol {
    
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
    
    func postLogout(_ requestBody: PostLogoutRequest, completion: @escaping (NetworkResult<EmptyResponse>) -> Void) {
        self.provider.request(.postLogout(requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult = self.judgeStatus(
                    statusCode: response.statusCode,
                    data: response.data,
                    type: EmptyResponse.self
                )
                completion(networkResult)
            case .failure(let response):
                print("⚙️Logout post failed :( \nLogoutResponse: \(response)")
            }
        }
    }
    
    func postReissue(_ requestBody: PostReissueRequest, completion: @escaping (NetworkResult<PostReissueResponse>) -> Void) {
        self.provider.request(.postReissue(requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PostReissueResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: PostReissueResponse.self)
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }
    
}
