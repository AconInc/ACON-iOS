//
//  OnboardingViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/16/25.
//

import Foundation

class OnboardingViewModel: Serviceable {
    
    // MARK: - Networking Properties
    
    var onPutOnboardingSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
 
    
    // MARK: - Networking
    
    func putOnboarding(_ dislikeFoodList: [String]) {
        ACService.shared.onboardingService.putOnboarding(requestBody: PutOnboardingRequest(dislikeFoodList: dislikeFoodList)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success:
                onPutOnboardingSuccess.value = true
            case .reIssueJWT:
                self.handleReissue {
                    self.putOnboarding(dislikeFoodList)
                }
            case .networkFail:
                self.handleNetworkError {
                    self.putOnboarding(dislikeFoodList)
                }
            default:
                onPutOnboardingSuccess.value = false
            }
        }
    }
    
}
