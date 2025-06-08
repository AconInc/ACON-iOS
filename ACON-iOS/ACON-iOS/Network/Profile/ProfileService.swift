//
//  ProfileService.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/15/25.
//

import Foundation

import Moya

protocol ProfileServiceProtocol {

    func getProfile(completion: @escaping (NetworkResult<GetProfileResponse>) -> Void)
    
    func getSavedSpots(completion: @escaping (NetworkResult<GetSavedSpotsResponse>) -> Void)
    
    func getNicknameValidity(parameter: GetNicknameValidityRequest,
                             completion: @escaping (NetworkResult<EmptyResponse>) -> Void)
    
    func patchProfile(requestBody: PatchProfileRequest,
                      completion: @escaping (NetworkResult<EmptyResponse>) -> Void)

}

final class ProfileService: BaseService<ProfileTargetType>, ProfileServiceProtocol {
    
    func getProfile(completion: @escaping (NetworkResult<GetProfileResponse>) -> Void) {
        self.provider.request(.getProfile) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetProfileResponse> = self.judgeStatus(
                    statusCode: response.statusCode,
                    data: response.data,
                    type: GetProfileResponse.self
                )
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }
    
    func getSavedSpots(completion: @escaping (NetworkResult<GetSavedSpotsResponse>) -> Void) {
        self.provider.request(.getSavedSpots) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetSavedSpotsResponse> = self.judgeStatus(
                    statusCode: response.statusCode,
                    data: response.data,
                    type: GetSavedSpotsResponse.self
                )
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }
    
    func getNicknameValidity(parameter: GetNicknameValidityRequest,
                             completion: @escaping (NetworkResult<EmptyResponse>) -> Void) {
        self.provider.request(.getNicknameValidity(parameter)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyResponse> = self.judgeStatus(
                    statusCode: response.statusCode,
                    data: response.data,
                    type: EmptyResponse.self
                )
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }
    
    func patchProfile(requestBody: PatchProfileRequest,
                      completion: @escaping (NetworkResult<EmptyResponse>) -> Void) {
        self.provider.request(.patchProfile(requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyResponse> = self.judgeStatus(
                    statusCode: response.statusCode,
                    data: response.data,
                    type: EmptyResponse.self
                )
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }

}
