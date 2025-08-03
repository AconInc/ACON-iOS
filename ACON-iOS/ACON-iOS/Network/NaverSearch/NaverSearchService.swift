//
//  NaverSearchService.swift
//  ACON-iOS
//
//  Created by 이수민 on 8/2/25.
//

import Foundation

import Moya

protocol NaverSearchServiceProtocol {
    
    func getNaverSearch(parameter: GetNaverSearchRequest,
                        completion: @escaping (NetworkResult<GetNaverSearchResponse>) -> Void)
    
}

final class NaverSearchService: BaseService<NaverSearchTargetType>, NaverSearchServiceProtocol {
    
    func getNaverSearch(parameter: GetNaverSearchRequest, completion: @escaping (NetworkResult<GetNaverSearchResponse>) -> Void) {
        self.provider.request(.getNaverSearch(parameter)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    let networkResult: NetworkResult<GetNaverSearchResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: GetNaverSearchResponse.self)
                    completion(networkResult)
                } else {
                    completion(.naverAPIErr(response.statusCode))
                }
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
}
