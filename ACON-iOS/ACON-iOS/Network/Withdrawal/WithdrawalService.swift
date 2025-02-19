//
//  WithdrawalService.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/18/25.
//

import UIKit

final class WithdrawalService: BaseService<WithdrawalTargetType> {
    
    func postWithdrawal(
        _ requestBody: WithdrawalRequest,
        completion: @escaping (NetworkResult<EmptyResponse>) -> Void
    ) {
        
        self.provider.request(.postWithdrawal(requestBody: requestBody)) { result in
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

