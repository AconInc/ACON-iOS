//
//  SpotSearchViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import Foundation
import CoreLocation

class SpotSearchViewModel: Serviceable {
    
    // MARK: - Properties
    
    var longitude: Double = 0
    
    var latitude: Double = 0
    
    let isLocationReady: ObservablePattern<Bool> = ObservablePattern(nil)
    
    let onSuccessGetSearchSuggestion: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var searchSuggestionData: ObservablePattern<[SearchSuggestionModel]> = ObservablePattern(nil)
    
    let onSuccessGetSearchKeyword: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var searchKeywordData: ObservablePattern<[SearchKeywordModel]> = ObservablePattern(nil)
    
    let onSuccessGetReviewVerification: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var reviewVerification: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var reviewVerificationErrorType: ReviewVerificationErrorType? = nil
    
    
    // MARK: - LifeCycle
    
    init() {
        ACLocationManager.shared.addDelegate(self)
    }
    
    deinit {
       ACLocationManager.shared.removeDelegate(self)
    }
    
    func getSearchKeyword(keyword: String) {
        let parameter = GetSearchKeywordRequest(keyword: keyword)
        
        ACService.shared.uploadService.getSearchKeyword(parameter: parameter) { [weak self] response in
            switch response {
            case .success(let data):
                self?.onSuccessGetSearchKeyword.value = true
                let searchKeywords = data.spotList.map { keyword in
                    return SearchKeywordModel(
                        spotID: keyword.spotId,
                        spotName: keyword.name,
                        spotAddress: keyword.address,
                        spotType: keyword.spotType.koreanText
                    )
                }
                self?.searchKeywordData.value = searchKeywords
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.getSearchKeyword(keyword: keyword)
                }
            default:
                self?.handleNetworkError { [weak self] in
                    self?.getSearchKeyword(keyword: keyword)
                }
            }
        }
    }
    
    func getSearchSuggestion() {
        let parameter = GetSearchSuggestionRequest(latitude: latitude, longitude: longitude)
        
        ACService.shared.uploadService.getSearchSuggestion(parameter: parameter) { [weak self] response in
            switch response {
            case .success(let data):
                let searchSuggestionData = data.suggestionList.map { suggestion in
                    return SearchSuggestionModel(spotID: suggestion.spotId,
                                                 spotName: suggestion.name)
                }
                self?.searchSuggestionData.value = searchSuggestionData
                self?.onSuccessGetSearchSuggestion.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.getSearchSuggestion()
                }
            case .requestErr(let error):
                if error.code == 40403 {
                    self?.reviewVerificationErrorType = .unknownSpot
                } else if error.code == 40405 {
                    self?.reviewVerificationErrorType = .unsupportedRegion
                } else {
                    self?.handleNetworkError { [weak self] in
                        self?.getSearchSuggestion()
                    }
                }
                self?.onSuccessGetSearchSuggestion.value = false
            default:
                self?.handleNetworkError { [weak self] in
                    self?.getSearchSuggestion()
                }
            }
        }
    }
    
    func getReviewVerification(spotId: Int64) {
        let parameter = GetReviewVerificationRequest(spotId: spotId,
                                                     latitude: self.latitude,
                                                     longitude: self.longitude)
        ACService.shared.uploadService.getReviewVerification(parameter: parameter) { [weak self] response in
            switch response {
            case .success(let data):
                self?.reviewVerification.value = data.available
                self?.onSuccessGetReviewVerification.value = true
            case .requestErr(let error):
                if error.code == 40403 {
                    self?.reviewVerificationErrorType = .unknownSpot
                } else if error.code == 40405 {
                    self?.reviewVerificationErrorType = .unsupportedRegion
                } else {
                    self?.handleNetworkError { [weak self] in
                        self?.getReviewVerification(spotId: spotId)
                    }
                }
                self?.onSuccessGetReviewVerification.value = false
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.getReviewVerification(spotId: spotId)
                }
            default:
                self?.handleNetworkError { [weak self] in
                    self?.getReviewVerification(spotId: spotId)
                }
            }
        }
    }
    
    func checkLocation() {
        ACLocationManager.shared.checkUserDeviceLocationServiceAuthorization()
    }
    
}

// MARK: - ACLocationManagerDelegate

extension SpotSearchViewModel: ACLocationManagerDelegate {
    
    func locationManager(_ manager: ACLocationManager, didUpdateLocation location: CLLocation) {
        ACLocationManager.shared.removeDelegate(self)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            print("성공 - 위도: \(location.coordinate.latitude), 경도: \(location.coordinate.longitude)")
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            self.isLocationReady.value = true
        }
    }
    
}
