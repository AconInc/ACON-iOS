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
                                completion: @escaping (Bool) -> Void)
    
}

final class ImageService: BaseService<ImageTargetType>, ImageServiceProtocol {
    
    func getPresignedURL(parameter: GetPresignedURLRequest, completion: @escaping (NetworkResult<GetPresignedURLResponse>) -> Void) {
        self.provider.request(.getPresignedURL(parameter)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetPresignedURLResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: GetPresignedURLResponse.self)
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }
    
    func putImageToPresignedURL(requestBody: PutImageToPresignedURLRequest, completion: @escaping (Bool) -> Void) {
        self.provider.request(.putImageToPresignedURL(requestBody)) { result in
            switch result {
            case .success(let response):
                completion(response.statusCode == 200)
            case .failure:
                completion(false)
            }
        }
    }

}
