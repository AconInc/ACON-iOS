//
//  OnboardingService.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/16/25.
//

import Foundation

import Moya

protocol OnboardingServiceProtocol {
    
    func putOnboarding(requestBody: PutOnboardingRequest,
                       completion: @escaping (NetworkResult<EmptyResponse>) -> Void)
    
}

final class OnboardingService: BaseService<OnboardingTargetType>, OnboardingServiceProtocol {
    
    func putOnboarding(requestBody: PutOnboardingRequest, completion: @escaping (NetworkResult<EmptyResponse>) -> Void) {
        self.provider.request(.putOnboarding(requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: EmptyResponse.self)
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }
    
}
