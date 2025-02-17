//
//  LocalVerificationEditViewModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/17/25.
//

import Foundation

class LocalVerificationEditViewModel {
    
    // MARK: - Properties
    
    var verifiedAreaList: [VerifiedAreaModel] = []
    
    var onGetVerifiedAreaListSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var isAppendingVerifiedAreaList: Bool = false
    
    
    // MARK: - Networking
    
    func getVerifiedAreaList() {
        // TODO: API 호출
        
        verifiedAreaList = [VerifiedAreaModel(id: 9999, name: "아콘동"),
                            VerifiedAreaModel(id: 033, name: "유림동")
        ]
        
        onGetVerifiedAreaListSuccess.value = true
//        onGetVerifiedAreaListSuccess.value = false
    }
    
}
