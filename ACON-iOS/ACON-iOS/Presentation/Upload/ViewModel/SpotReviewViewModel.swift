//
//  SpotReviewViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/17/25.
//

import Foundation

class SpotReviewViewModel: Serviceable {
    
//    let onSuccessGetAcornCount: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var acornCount: ObservablePattern<Int> = ObservablePattern(nil)
    
    let onSuccessPostReview: ObservablePattern<Bool> = ObservablePattern(nil)
    
//    func getAcornCount() {
//        ACService.shared.uploadService.getAcornCount { [weak self] response in
//            switch response {
//            case .success(let data):
//                self?.acornCount.value = data.acornCount
//                self?.onSuccessGetAcornCount.value = true
//            case .reIssueJWT:
//                self?.handleReissue { [weak self] in
//                    self?.getAcornCount()
//                }
//            default:
//                print("VM - Fail to getAcornCount")
//                self?.onSuccessGetAcornCount.value = false
//            }
//        }
//    }
    
    func postReview(spotID: Int64, acornCount: Int) {
        ACService.shared.uploadService.postReview(requestBody: PostReviewRequest(spotId: spotID, acornCount: acornCount)) { [weak self] response in
            switch response {
            case .success(_):
                self?.onSuccessPostReview.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postReview(spotID: spotID, acornCount: acornCount)
                }
            default:
                print("VM - Fail to postReview")
                self?.onSuccessPostReview.value = false
                return
            }
        }
    }
}

