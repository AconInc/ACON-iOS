//
//  SpotListService.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/21/25.
//

import Foundation

import Moya

protocol SpotListServiceProtocol {

    func postSpotList(requestBody: PostSpotListRequest, completion: @escaping (NetworkResult<PostSpotListResponse>) -> Void)

}

final class SpotListService: BaseService<SpotListTargetType>, SpotListServiceProtocol{
    
    func postSpotList(requestBody: PostSpotListRequest,
                      completion: @escaping (NetworkResult<PostSpotListResponse>) -> Void) {
        self.provider.request(.postSpotList(requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PostSpotListResponse> = self.judgeStatus(
                    statusCode: response.statusCode,
                    data: response.data,
                    type: PostSpotListResponse.self
                )
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }

}
