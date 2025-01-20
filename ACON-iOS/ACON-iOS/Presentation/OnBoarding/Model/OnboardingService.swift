//
//  OnboardingService.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/15/25.
//

import UIKit

final class OnboardingService: BaseService<OnboardingAPI> {
    func postOnboarding(
        onboardingData: OnboardingDTO,
        completion: @escaping (NetworkResult<EmptyResponse>) -> Void
    ) {
        self.request(
            type: EmptyResponse.self,
            target: .postOnboarding(data: onboardingData),
            completion: completion
        )
    }
}
