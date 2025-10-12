//
//  PreferenceService.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/16/25.
//

import Foundation

import Moya

protocol PreferenceServiceProtocol {
    
    func putPreference(requestBody: PutPreferenceRequest,
                       completion: @escaping (NetworkResult<EmptyResponse>) -> Void)
    
}

final class PreferenceService: BaseService<PreferenceTargetType>, PreferenceServiceProtocol {
    
    func putPreference(requestBody: PutPreferenceRequest, completion: @escaping (NetworkResult<EmptyResponse>) -> Void) {
        self.provider.request(.putPreference(requestBody)) { result in
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
