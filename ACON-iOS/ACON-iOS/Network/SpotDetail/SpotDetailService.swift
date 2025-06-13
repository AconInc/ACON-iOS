//
//  SpotDetailService.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/21/25.
//

import Foundation

import Moya

protocol SpotDetailServiceProtocol {

    func getSpotDetail(spotID: Int64,
                       completion: @escaping (NetworkResult<GetSpotDetailResponse>) -> Void)
    func getSpotMenu(spotID: Int64,
                     completion: @escaping (NetworkResult<GetSpotMenuResponse>) -> Void)
    func postGuidedSpot(spotID: Int64,
                        completion: @escaping (NetworkResult<EmptyResponse>) -> Void)
    func postSavedSpot(spotID: Int64,
                       completion: @escaping (NetworkResult<EmptyResponse>) -> Void)
    func deleteSavedSpot(spotID: Int64,
                         completion: @escaping (NetworkResult<EmptyResponse>) -> Void)

}

final class SpotDetailService: BaseService<SpotDetailTargetType>,
                               SpotDetailServiceProtocol {

    func getSpotDetail(spotID: Int64, completion: @escaping (NetworkResult<GetSpotDetailResponse>) -> Void) {
        self.provider.request(.getSpotDetail(spotID: spotID)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetSpotDetailResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: GetSpotDetailResponse.self)
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }

    func getSpotMenu(spotID: Int64,
                     completion: @escaping (NetworkResult<GetSpotMenuResponse>) -> Void) {
        self.provider.request(.getSpotMenu(spotID: spotID)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetSpotMenuResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: GetSpotMenuResponse.self)
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }

    func postGuidedSpot(spotID: Int64,
                        completion: @escaping (NetworkResult<EmptyResponse>) -> Void) {
        self.provider.request(.postGuidedSpot(spotID: spotID)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: EmptyResponse.self)
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }

    func postSavedSpot(spotID: Int64, completion: @escaping (NetworkResult<EmptyResponse>) -> Void) {
        self.provider.request(.postSavedSpot(spotID: spotID)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: EmptyResponse.self)
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }

    func deleteSavedSpot(spotID: Int64, completion: @escaping (NetworkResult<EmptyResponse>) -> Void) {
        self.provider.request(.postSavedSpot(spotID: spotID)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyResponse> = self.judgeStatus(statusCode: response.statusCode, data: response.data, type: EmptyResponse.self)
                completion(networkResult)
            case .failure(let errorResponse):
                print(errorResponse)
            }
        }
    }

}
