//
//  GetSearchSuggestionResponse.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/21/25.
//

import Foundation

struct GetSearchSuggestionResponse: Codable {
    
    let suggestionList: [SearchSuggestionKeyword]
    
}

struct SearchSuggestionKeyword: Codable {
    
    let spotId: Int64
    
    let name: String
    
}
