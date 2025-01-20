//
//  SpotSearchViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import Foundation

class SpotSearchViewModel {
    
    // TODO: - 추후 기본값 nil로 변경
    let onSuccessGetSearchSuggestion: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var searchSuggestionData: ObservablePattern<SearchSuggestionModel> = ObservablePattern(nil)
    
    let onSuccessGetSearchKeyword: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var searchKeywordData: ObservablePattern<[SearchKeywordModel]> = ObservablePattern(nil)
    
    let updateSearchKeyword: ObservablePattern<Bool> = ObservablePattern(nil)
    
    // TODO: - search keyword 엠티뷰와 분기처리 (data.count == 0 ? )
//    
//    let searchKeywordDummyData: [SearchKeywordModel] = [
//        SearchKeywordModel(spotID: 1, spotName: "1가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "음식점"),
//        SearchKeywordModel(spotID: 2, spotName: "2가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "카페"),
//        SearchKeywordModel(spotID: 3, spotName: "3가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "음식점"),
//        SearchKeywordModel(spotID: 1, spotName: "1가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "음식점"),
//        SearchKeywordModel(spotID: 2, spotName: "2가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "카페"),
//        SearchKeywordModel(spotID: 3, spotName: "3가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "음식점"),
//        SearchKeywordModel(spotID: 1, spotName: "1가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "음식점"),
//        SearchKeywordModel(spotID: 2, spotName: "2가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "카페"),
//        SearchKeywordModel(spotID: 3, spotName: "3가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "음식점"),
//        SearchKeywordModel(spotID: 1, spotName: "1가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "음식점")
//    ]
    
    let searchSuggestionDummyData: SearchSuggestionModel = SearchSuggestionModel(spotList: ["하이디라오", "신의주찹쌀순대", "뭐시기저시기", "카이센동우니도", "하잉"])
    
    init() {
        self.searchSuggestionData.value = searchSuggestionDummyData
        self.onSuccessGetSearchSuggestion.value = true
//        self.searchKeywordData.value = searchKeywordDummyData
//        self.onSuccessGetSearchKeyword.value = true
        // TODO: - 나중에 뷰모델에서 기존 키워드와 같은지 보고 updateKeyword.value = false
        self.updateSearchKeyword.value = true
    }
    
    func getSearchKeyword(keyword: String) {
        let parameter = GetSearchKeywordRequest(keyword: keyword)
        
        ACService.shared.uploadService.getSearchKeyword(parameter: parameter) { [weak self] response in
            switch response {
            case .success(let data):
                self?.onSuccessGetSearchKeyword.value = true
                let searchKeywords = data.suggestionList.map { keyword in
                    return SearchKeywordModel(
                        spotID: keyword.spotId,
                        spotName: keyword.spotName,
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
    
}
