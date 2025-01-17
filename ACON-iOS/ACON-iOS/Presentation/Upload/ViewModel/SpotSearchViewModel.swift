//
//  SpotSearchViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import Foundation

class SpotSearchViewModel {
    
    // TODO: - search keyword 엠티뷰와 분기처리 (data.count == 0 ? )
    
    let searchKeywordDummyData: [SearchKeywordModel] = [
        SearchKeywordModel(spotID: 1, spotName: "1가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "음식점"),
        SearchKeywordModel(spotID: 2, spotName: "2가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "카페"),
        SearchKeywordModel(spotID: 3, spotName: "3가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "음식점"),
        SearchKeywordModel(spotID: 1, spotName: "1가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "음식점"),
        SearchKeywordModel(spotID: 2, spotName: "2가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "카페"),
        SearchKeywordModel(spotID: 3, spotName: "3가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "음식점"),
        SearchKeywordModel(spotID: 1, spotName: "1가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "음식점"),
        SearchKeywordModel(spotID: 2, spotName: "2가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "카페"),
        SearchKeywordModel(spotID: 3, spotName: "3가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "음식점"),
        SearchKeywordModel(spotID: 1, spotName: "1가게명가게명", spotAddress: "서울시 서울구 서울동 123", spotType: "음식점")
    ]
    
    let searchSuggestionDummyData: SearchSuggestionModel = SearchSuggestionModel(spotList: ["하이디라오", "신의주찹쌀순대", "뭐시기저시기", "카이센동우니도", "하잉"])
    
}
