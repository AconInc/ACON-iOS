//
//  SpotUploadSearchViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 8/2/25.
//

import Foundation
import CoreLocation

class SpotUploadSearchViewModel: Serviceable {
    
    // MARK: - Properties

    var naverSearchStatusCode: ObservablePattern<Int> = ObservablePattern(nil)
    
    var naverSearchResult: ObservablePattern<[SearchKeywordModel]> = ObservablePattern(nil)
    
    
    // MARK: - API 통신
    
    func getNaverSearchResult(keyword: String) {
        let parameter = GetNaverSearchRequest(query: keyword)

        ACService.shared.naverSearchService.getNaverSearch(parameter: parameter) { [weak self] response in
            switch response {
            case .success(let data):
                let searchKeywords = data.items.map { keyword in
                    let title = keyword.title.replacingOccurrences(of: "<b>", with: "")
                        .replacingOccurrences(of: "</b>", with: "")
                        .replacingOccurrences(of: "\\/", with: "/")
                    let address = keyword.roadAddress == "" ? keyword.address : keyword.roadAddress
                    return SearchKeywordModel(
                        spotID: nil,
                        spotName: title,
                        spotAddress: address,
                        spotType: self?.convertNaverCategory(keyword.category)
                    )
                }
                self?.naverSearchResult.value = searchKeywords
                self?.naverSearchStatusCode.value = 200
            case .naverAPIErr(let statusCode):
                self?.naverSearchStatusCode.value = statusCode
            default:
                self?.handleNetworkError { [weak self] in
                    self?.getNaverSearchResult(keyword: keyword)
                }
            }
        }
    }
    
}


// MARK: - Helper

private extension SpotUploadSearchViewModel {
    
    func convertNaverCategory(_ category: String) -> String {
        let foodCategories = ["카페,디저트", "음식점", "술집"]
        
        let menuCategories = ["한식", "중식", "일식", "양식", "분식", "베트남음식", "태국음식", "인도음식"]
        
        if foodCategories.contains(where: { category.contains($0) }) {
            if category.contains("카페,디저트") {
                return "카페"
            } else if category.contains("술집") {
                return "술집"
            } else if category.contains("음식점") {
                return "음식점"
            }
        }
        
        if menuCategories.contains(where: { category.contains($0) }) {
            return "음식점"
        }
        
        return ""
    }
    
}

