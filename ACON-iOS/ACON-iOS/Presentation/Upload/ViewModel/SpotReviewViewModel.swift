//
//  SpotReviewViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/17/25.
//

import Foundation

class SpotReviewViewModel {
    
    let onSuccessGetAcornNum: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var acornNum: ObservablePattern<AcornCountModel> = ObservablePattern(nil)
    
    let onSuccessPostReview: ObservablePattern<Bool> = ObservablePattern(nil)
    
    let onSuccessGetReviewVerification: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var reviewVerification: ObservablePattern<Bool> = ObservablePattern(nil)

    let acornNumDummyData: AcornCountModel = AcornCountModel(acornCount: 3)
    
    let reviewVerificationDummyData: Bool = true
    
    init() {
        self.acornNum.value = acornNumDummyData
        self.onSuccessGetAcornNum.value = true
        self.onSuccessPostReview.value = true
        self.onSuccessGetReviewVerification.value = true
        self.reviewVerification.value = reviewVerificationDummyData
    }
    
}
