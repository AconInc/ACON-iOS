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
    
    func postDeleteVerifiedArea(_ area: VerifiedAreaModel, completion: @escaping (Result<Bool, Error>) -> Void) {
        print("postDeleteVerifiedArea")
        
        // TODO: API 요청 추가
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let isSuccess = Bool.random() // NOTE: 임시로 성공/실패를 랜덤 처리
            if isSuccess {
                completion(.success(true))
            } else {
                completion(.failure(NSError(domain: "DeleteError", code: 400, userInfo: [NSLocalizedDescriptionKey: "삭제 실패"])))
            }
        }
    }
    
}
