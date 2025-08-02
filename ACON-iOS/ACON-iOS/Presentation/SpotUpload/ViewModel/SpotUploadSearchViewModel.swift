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
    
    let onSuccessGetNaverSearch: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var naverSearchResult: ObservablePattern<[SearchKeywordModel]> = ObservablePattern(nil)
    
    
    // MARK: - API 통신
    
    func getNaverSearchResult(keyword: String) {
        let parameter = GetNaverSearchRequest(query: keyword)

        ACService.shared.naverSearchService.getNaverSearch(parameter: parameter) { [weak self] response in
            switch response {
            case .success(let data):
                self?.onSuccessGetNaverSearch.value = true
                let searchKeywords = data.items.map { keyword in
                    let cleanTitle = keyword.title.replacingOccurrences(of: "<b>", with: "")
                        .replacingOccurrences(of: "</b>", with: "")
                        .replacingOccurrences(of: "\\/", with: "/")
                    let address = keyword.roadAddress == "" ? keyword.address : keyword.roadAddress
                    return SearchKeywordModel(
                        spotID: nil,
                        spotName: cleanTitle,
                        spotAddress: address,
                        spotType: nil
                    )
                }
                self?.naverSearchResult.value = searchKeywords
                print("🩵", self?.naverSearchResult.value)
            default:
                self?.handleNetworkError { [weak self] in
                    self?.getNaverSearchResult(keyword: keyword)
                }
            }
        }
    }
    
}
