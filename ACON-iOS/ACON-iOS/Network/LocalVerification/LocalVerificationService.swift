//
//  LocalVerificationService.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import Foundation

import Moya

protocol LocalVerificationServiceProtocol {
    
    func postLocalArea(requestBody: PostLocalAreaRequest, completion: @escaping (NetworkResult<PostLocalAreaResponse>) -> Void)
    
}

final class LocalVerificationService: BaseService<LocalVerificationTargetType>, LocalVerificationServiceProtocol {

    let service = BaseService<LocalVerificationTargetType>()

    func postLocalArea(requestBody: PostLocalAreaRequest,
                       completion: @escaping (NetworkResult<PostLocalAreaResponse>) -> Void) {
        service.provider.request(.postLocalArea(requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PostLocalAreaResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: PostLocalAreaResponse.self)
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }
    
}
