//
//  SpotReviewViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/17/25.
//

import Foundation

class SpotReviewViewModel: Serviceable {

    // MARK: - Properties

    let spotID: Int64

    let spotName: String

    var recommendedMenu: String = ""

    var acornCount: ObservablePattern<Int> = ObservablePattern(nil)

    let onSuccessPostReview: ObservablePattern<Bool> = ObservablePattern(nil)


    // MARK: - init

    init(spotID: Int64, spotName: String) {
        self.spotID = spotID
        self.spotName = spotName
    }


    func postReview(acornCount: Int) {
        ACService.shared.uploadService.postReview(requestBody: PostReviewRequest(spotId: spotID, acornCount: acornCount)) { [weak self] response in
            switch response {
            case .success(_):
                self?.onSuccessPostReview.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postReview(acornCount: acornCount)
                }
            default:
                self?.handleNetworkError { [weak self] in
                    self?.postReview(acornCount: acornCount)
                }
            }
        }
    }
}

