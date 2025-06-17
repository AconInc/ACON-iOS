//
//  ImageService.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/17/25.
//

import Foundation

import Moya

protocol ImageServiceProtocol {
    
    func getPresignedURL(parameter: GetPresignedURLRequest,
                         completion: @escaping (NetworkResult<GetPresignedURLResponse>) -> Void)
    
    func putImageToPresignedURL(requestBody: PutImageToPresignedURLRequest,
                                completion: @escaping (NetworkResult<EmptyResponse>) -> Void)
    
}

final class ImageService: BaseService<ImageTargetType>, ImageServiceProtocol {
    
    func getPresignedURL(parameter: GetPresignedURLRequest, completion: @escaping (NetworkResult<GetPresignedURLResponse>) -> Void) {
        self.provider.request(.getPresignedURL(parameter)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetPresignedURLResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: GetPresignedURLResponse.self)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func putImageToPresignedURL(requestBody: PutImageToPresignedURLRequest, completion: @escaping (NetworkResult<EmptyResponse>) -> Void) {
        self.provider.request(.putImageToPresignedURL(requestBody)) { result in
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
