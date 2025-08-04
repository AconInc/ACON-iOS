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

    var acornCount: Int = 0

    let onSuccessPostReview: ObservablePattern<Bool> = ObservablePattern(nil)


    // MARK: - init

    init(spotID: Int64, spotName: String) {
        self.spotID = spotID
        self.spotName = spotName
    }


    // MARK: - Network

    func postReview() {
        ACService.shared.uploadService.postReview(requestBody: PostReviewRequest(spotId: spotID, acornCount: acornCount)) { [weak self] response in
            switch response {
            case .success(_):
                self?.onSuccessPostReview.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postReview()
                }
            default:
                self?.handleNetworkError { [weak self] in
                    self?.postReview()
                }
            }
        }
    }

}
