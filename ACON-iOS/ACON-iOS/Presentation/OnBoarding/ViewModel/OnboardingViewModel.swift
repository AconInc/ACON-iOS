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
    
    // TODO : NetWorking
}

