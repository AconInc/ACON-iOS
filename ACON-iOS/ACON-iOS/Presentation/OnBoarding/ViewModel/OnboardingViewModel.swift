//
//  OnboardingViewModel.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/15/25.
//

import Foundation

final class OnboardingViewModel {
    var dislike: ObservablePattern<[String]> = ObservablePattern([])
    var favoriteCuisne: ObservablePattern<[String]> = ObservablePattern([])
    var favoriteSpotType: ObservablePattern<String> = ObservablePattern(nil)
    var favoriteSpotStyle: ObservablePattern<String> = ObservablePattern(nil)
    var favoriteSpotRank: ObservablePattern<[String]> = ObservablePattern([])
}

struct Mappings {
    
    static let dislikeOptions = ["DAKBAL", "HOE_YUKHOE", "GOPCHANG", "SUNDAE", "YANGGOGI", "NONE"]
    static let favoriteCuisines = ["KOREAN", "WESTERN", "CHINESE", "JAPANESE", "KOREAN_STREET", "ASIAN"]
    static let favoriteSpotTypes = ["RESTAURANT", "CAFE"]
    static let favoriteSpotStyles = ["TRADITIONAL", "MODERN"]
    static let favoriteSpotRanks = ["SENSE", "NEW_FOOD", "REASONABLE", "LUXURY"]
}
