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
    
    var postOnboardingResult: ObservablePattern<Bool> = ObservablePattern(nil)
    

    func postOnboarding() {
        
        let processedDislikeFoodList: [String] = {
               if let dislikeList = dislike.value, dislikeList.contains("NONE") {
                   //dislikefood none -> case 400 error , so 임시 
                   return []
               }
               return dislike.value ?? [" "]
           }()
        
        let onboardingData = OnboardingRequest(dislikeFoodList: processedDislikeFoodList,
                                               favoriteCuisineRank: favoriteCuisne.value ?? [""],
                                               favoriteSpotType: favoriteSpotType.value ?? "",
                                               favoriteSpotStyle: favoriteSpotStyle.value ?? "",
                                               favoriteSpotRank: favoriteSpotRank.value ?? [""])
        
        print(onboardingData)
        
        ACService.shared.onboardingService.postOnboarding(requestBody: onboardingData) { [weak self] response in
            guard let self else { return }
            
            switch response {
            case .success(_):
                print("Onboarding Success")
                self.postOnboardingResult.value = true
            default:
                print("Onboarding Failed")
                self.postOnboardingResult.value = false
            }
        }
    }
    
}

