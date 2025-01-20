//
//  OnboardingDTO.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/20/25.
//

import Foundation

struct OnboardingDTO: Codable {
    let dislikeFoodList: [String]
    let favoriteCuisineRank: [String]
    let favoriteSpotType: String
    let favoriteSpotStyle: String
    let favoriteSpotRank: [String]
}
