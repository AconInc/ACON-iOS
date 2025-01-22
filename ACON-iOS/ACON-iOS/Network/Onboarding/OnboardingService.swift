//
//  OnboardingService.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/15/25.
//

import UIKit

final class OnboardingService: BaseService<OnboardingTargetType> {
    
    func postOnboarding(
        requestBody: OnboardingRequest,
        completion: @escaping (NetworkResult<EmptyResponse>) -> Void
    ) {
        
        self.provider.request(.postOnboarding(requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                print("⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️")
                let networkResult = self.judgeStatus(
                    statusCode: response.statusCode,
                    data: response.data,
                    type: EmptyResponse.self
                )
                completion(networkResult)
            case .failure(let errorResponse):
                print("⭐️")
                print(errorResponse)
            }
            
        }
        
    }
}

