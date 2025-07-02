//
//  AppService.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/20/25.
//

import Foundation

import Moya

protocol AppServiceProtocol {
    
    func getAppUpdate(parameter: GetAppUpdateRequest,
                       completion: @escaping (NetworkResult<GetAppUpdateResponse>) -> Void)
    
}

final class AppService: BaseService<AppTargetType>, AppServiceProtocol {

    func getAppUpdate(parameter: GetAppUpdateRequest,
                       completion: @escaping (NetworkResult<GetAppUpdateResponse>) -> Void) {
        self.provider.request(.getAppUpdate(parameter)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetAppUpdateResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: GetAppUpdateResponse.self)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
  
}
