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

}
