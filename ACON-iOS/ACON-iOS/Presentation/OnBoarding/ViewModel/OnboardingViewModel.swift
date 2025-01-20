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
    
    let onSuccessPostOnboarding: ObservablePattern<Bool> = ObservablePattern(nil)
    
    func postOnboarding(completion: @escaping (Bool) -> Void) {
        
        let onboardingData = OnboardingRequest(dislikeFoodList: dislike.value ?? [""],
                                           favoriteCuisineRank: favoriteCuisne.value ?? [""],
                                           favoriteSpotType: favoriteSpotType.value ?? "",
                                           favoriteSpotStyle: favoriteSpotStyle.value ?? "",
                                           favoriteSpotRank: favoriteSpotRank.value ?? [""])
        
        print(onboardingData)
        
        ACService.shared.onboardingService.postOnboarding(onboardingData: onboardingData) { [weak self] response in
            switch response {
            case .success(_):
                self?.onSuccessPostOnboarding.value = true
                print("good")
                completion(true) // 성공 시 true 반환

            default:
                self?.onSuccessPostOnboarding.value = false
                print("bad")
                completion(false) // 성공 시 true 반환
            }
        }
    }
}

