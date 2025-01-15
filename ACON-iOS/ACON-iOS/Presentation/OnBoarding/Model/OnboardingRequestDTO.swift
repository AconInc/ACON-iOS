//
//  OnboardingRequestDTO.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/15/25.
//

import Foundation

struct OnboardingRequestDTO: Codable {
    let dislikeFoodList: [String]
    let favoriteCuisineRank: [String]
    let favoriteSpotType: String
    let favoriteSpotStyle: String
    let favoriteSpotRank: [String]
}
