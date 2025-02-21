//
//  SpotSearchViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import Foundation

class SpotSearchViewModel: Serviceable {
    
    var longitude: Double
    
    var latitude: Double
    
    let onSuccessGetSearchSuggestion: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var searchSuggestionData: ObservablePattern<[SearchSuggestionModel]> = ObservablePattern(nil)
    
    let onSuccessGetSearchKeyword: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var searchKeywordData: ObservablePattern<[SearchKeywordModel]> = ObservablePattern(nil)
    
    let onSuccessGetReviewVerification: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var reviewVerification: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var reviewVerificationErrorType: ReviewVerificationErrorType? = nil
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
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
                print("VM - Fail to getSearchKeyword")
                self?.onSuccessGetSearchKeyword.value = false
                return
            }
        }
    }
    
    func getSearchSuggestion() {
        let parameter = GetSearchSuggestionRequest(latitude: latitude, longitude: longitude)
        
        ACService.shared.uploadService.getSearchSuggestion(parameter: parameter) { [weak self] response in
            switch response {
            case .success(let data):
                let searchSuggestionData = data.suggestionList.map { suggestion in
                    return SearchSuggestionModel(spotId: suggestion.spotId,
                                                 spotName: suggestion.spotName)
                }
                self?.searchSuggestionData.value = searchSuggestionData
                self?.onSuccessGetSearchSuggestion.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.getSearchSuggestion()
                }
            case .requestErr(let error):
                print("🥑getSearchSuggestion requestErr: \(error)")
                if error.code == 40403 {
                    self?.reviewVerificationErrorType = .unknownSpot
                } else if error.code == 40405 {
                    self?.reviewVerificationErrorType = .unsupportedRegion
                }
                self?.onSuccessGetSearchSuggestion.value = false
            default:
                print("VM - Fail to getSearchSuggestion")
                self?.onSuccessGetSearchSuggestion.value = false
                return
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
                self?.reviewVerification.value = data.success
                self?.onSuccessGetReviewVerification.value = true
            case .requestErr(let error):
                print("🥑get reviewVerification requestErr: \(error)")
                if error.code == 40403 {
                    self?.reviewVerificationErrorType = .unknownSpot
                } else if error.code == 40405 {
                    self?.reviewVerificationErrorType = .unsupportedRegion
                }
                self?.onSuccessGetReviewVerification.value = false
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.getReviewVerification(spotId: spotId)
                }
            default:
                print("VM - Fail to get review verification")
                self?.onSuccessGetReviewVerification.value = false
                return
            }
        }
    }
    
}
