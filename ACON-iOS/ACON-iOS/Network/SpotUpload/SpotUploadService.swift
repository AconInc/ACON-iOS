//
//  SpotUploadService.swift
//  ACON-iOS
//
//  Created by 김유림 on 8/5/25.
//

import Foundation

import Moya

protocol SpotUploadServiceProtocol {

    func postSpotUpload(requestBody: PostSpotUploadRequest,
                        completion: @escaping (NetworkResult<EmptyResponse>) -> Void)

}

final class SpotUploadService: BaseService<SpotUploadTargetType>, SpotUploadServiceProtocol {

    func postSpotUpload(requestBody: PostSpotUploadRequest, completion: @escaping (NetworkResult<EmptyResponse>) -> Void) {
        self.provider.request(.postSpotUpload(requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: EmptyResponse.self)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }

}
