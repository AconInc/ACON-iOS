//
//  LocalVerificationService.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import Foundation

import Moya

protocol LocalVerificationServiceProtocol {
    
    func postLocalArea(requestBody: PostLocalAreaRequest, completion: @escaping (NetworkResult<EmptyResponse>) -> Void)
    
    func getVerifiedAreaList(completion: @escaping (NetworkResult<GetVerifiedAreaListResponse>) -> Void)
    
    func deleteVerifiedArea(verifiedAreaID: String,
                            completion: @escaping (NetworkResult<EmptyResponse>) -> Void)
    
    func postReplaceVerifiedArea(requestBody: PostReplaceVerifiedAreaRequest, completion: @escaping (NetworkResult<EmptyResponse>) -> Void)
}

final class LocalVerificationService: BaseService<LocalVerificationTargetType>, LocalVerificationServiceProtocol {

    func postLocalArea(requestBody: PostLocalAreaRequest,
                       completion: @escaping (NetworkResult<EmptyResponse>) -> Void) {
        self.provider.request(.postLocalArea(requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: EmptyResponse.self)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
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
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func deleteVerifiedArea(verifiedAreaID: String,
                            completion: @escaping (NetworkResult<EmptyResponse>) -> Void) {
        self.provider.request(.deleteLocalArea(verifiedAreaID)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyResponse> = self.judgeStatus(
                    statusCode: response.statusCode,
                    data: response.data,
                    type: EmptyResponse.self
                )
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func postReplaceVerifiedArea(requestBody: PostReplaceVerifiedAreaRequest, completion: @escaping (NetworkResult<EmptyResponse>) -> Void) {
        self.provider.request(.postReplaceLocalArea(requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyResponse> = self.judgeStatus(
                    statusCode: response.statusCode,
                    data: response.data,
                    type: EmptyResponse.self
                )
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }

}
