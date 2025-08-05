//
//  PostReviewRequest.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/21/25.
//

import Foundation

struct PostReviewRequest: Encodable {

    let spotId: Int64

    let recommendedMenu: String

    let acornCount: Int

}

