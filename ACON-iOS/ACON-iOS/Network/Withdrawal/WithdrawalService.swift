//
//  WithdrawalService.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/18/25.
//

import Foundation

import Moya

protocol WithdrawalProtocol {
    
    func postWithdrawal(
        _ requestBody: WithdrawalRequest,
        completion: @escaping (NetworkResult<EmptyResponse>) -> Void
    )
    
}

final class WithdrawalService: BaseService<WithdrawalTargetType>, WithdrawalProtocol {
    
    func postWithdrawal(
        _ requestBody: WithdrawalRequest,
        completion: @escaping (NetworkResult<EmptyResponse>) -> Void
    ) {
        
        self.provider.request(.postWithdrawal(requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult = self.judgeStatus(
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

