//
//  SpotSearchViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import Foundation

class SpotSearchViewModel {
    
    var longitude: Double
    
    var latitude: Double
    
    let onSuccessGetSearchSuggestion: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var searchSuggestionData: ObservablePattern<[SearchSuggestionModel]> = ObservablePattern(nil)
    
    let onSuccessGetSearchKeyword: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var searchKeywordData: ObservablePattern<[SearchKeywordModel]> = ObservablePattern(nil)
    
//    let searchSuggestionDummyData: SearchSuggestionModel = SearchSuggestionModel(spotList: ["하이디라오", "신의주찹쌀순대", "뭐시기저시기", "카이센동우니도", "하잉"])
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
//        self.searchSuggestionData.value = searchSuggestionDummyData
//        self.onSuccessGetSearchSuggestion.value = true
//        self.searchKeywordData.value = searchKeywordDummyData
//        self.onSuccessGetSearchKeyword.value = true
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
                        spotType: keyword.spotType
                    )
                }
                self?.searchKeywordData.value = searchKeywords
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
            default:
                print("VM - Fail to getSearchSuggestion")
                self?.onSuccessGetSearchSuggestion.value = false
                return
            }
        }
    }
    
}
