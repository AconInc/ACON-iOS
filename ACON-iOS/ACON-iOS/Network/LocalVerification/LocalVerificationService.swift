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
    
    func getVerifiedAreaList(completion: @escaping (NetworkResult<GetVerifiedAreaListResponse>) -> Void)
    
}

final class LocalVerificationService: BaseService<LocalVerificationTargetType>, LocalVerificationServiceProtocol {

    func postLocalArea(requestBody: PostLocalAreaRequest,
                       completion: @escaping (NetworkResult<PostLocalAreaResponse>) -> Void) {
        self.provider.request(.postLocalArea(requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PostLocalAreaResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: PostLocalAreaResponse.self)
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }
    
    func getVerifiedAreaList(completion: @escaping (NetworkResult<GetVerifiedAreaListResponse>) -> Void) {
        self.provider.request(.getLocalAreaList) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetVerifiedAreaListResponse> = self.judgeStatus(
                    statusCode: response.statusCode,
                    data: response.data,
                    type: GetVerifiedAreaListResponse.self
                )
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }
    
}
