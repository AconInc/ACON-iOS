//
//  UploadService.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/21/25.
//

import Foundation

import Moya

protocol UploadServiceProtocol {
    
    func getSearchSuggestion(parameter: GetSearchSuggestionRequest,
                             completion: @escaping (NetworkResult<GetSearchSuggestionResponse>) -> Void)
    func postReview(requestBody: PostReviewRequest,
                    completion: @escaping (NetworkResult<EmptyResponse>) -> Void)
    func getSearchKeyword(parameter: GetSearchKeywordRequest,
                          completion: @escaping (NetworkResult<GetSearchKeywordResponse>) -> Void)
    func getReviewVerification(parameter: GetReviewVerificationRequest,
                               completion: @escaping (NetworkResult<GetReviewVerificationResponse>) -> Void)
    func getAcornCount(completion: @escaping (NetworkResult<GetAcornCountResponse>) -> Void)
    
}

final class UploadService: BaseService<UploadTargetType>, UploadServiceProtocol {
    
    let service = BaseService<UploadTargetType>()
    
    func getSearchSuggestion(parameter: GetSearchSuggestionRequest,
                             completion: @escaping (NetworkResult<GetSearchSuggestionResponse>) -> Void) {
        service.provider.request(.getSearchSuggestion(parameter)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetSearchSuggestionResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: GetSearchSuggestionResponse.self)
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }
    
    func postReview(requestBody: PostReviewRequest, completion: @escaping (NetworkResult<EmptyResponse>) -> Void) {
        service.provider.request(.postReview) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: EmptyResponse.self)
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }
    
    func getSearchKeyword(parameter: GetSearchKeywordRequest, completion: @escaping (NetworkResult<GetSearchKeywordResponse>) -> Void) {
        service.provider.request(.getSearchKeyword(parameter)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetSearchKeywordResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: GetSearchKeywordResponse.self)
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }
    
    func getReviewVerification(parameter: GetReviewVerificationRequest, completion: @escaping (NetworkResult<GetReviewVerificationResponse>) -> Void) {
        service.provider.request(.getReviewVerification(parameter)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetReviewVerificationResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: GetReviewVerificationResponse.self)
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }
    
    func getAcornCount(completion: @escaping (NetworkResult<GetAcornCountResponse>) -> Void) {
        service.provider.request(.getAcornCount) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetAcornCountResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: GetAcornCountResponse.self)
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }

}
