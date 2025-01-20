//
//  TestService.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import Foundation

import Moya

protocol TestServiceProtocol {
    
    func getMenuList(spotID: Int, completion: @escaping (NetworkResult<TestResponse>) -> Void)
    
}

final class TestService: BaseService<TestTargetType>, TestServiceProtocol {

    let service = BaseService<TestTargetType>()

    func getMenuList(spotID: Int, completion: @escaping (NetworkResult<TestResponse>) -> Void) {
        service.provider.request(.getMenuList(spotID: spotID)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<TestResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: TestResponse.self)
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }
    
}
