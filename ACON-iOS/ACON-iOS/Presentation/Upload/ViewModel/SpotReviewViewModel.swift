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
    
    let acornNumDummyData: AcornCountModel = AcornCountModel(acornCount: 3)
    
    let onSuccessPostReview: ObservablePattern<Bool> = ObservablePattern(nil)

    init() {
        self.acornNum.value = acornNumDummyData
        self.onSuccessGetAcornNum.value = true
        self.onSuccessPostReview.value = true
    }
    
}
