//
//  PostSpotUploadRequest.swift
//  ACON-iOS
//
//  Created by 김유림 on 8/5/25.
//

import Foundation

struct PostSpotUploadRequest: Encodable {

    let spotName: String

    let address: String

    let spotType: String

    let featureList: [SpotUploadFeatureDTO]

    let recommendedMenu: String

    let imageList: [String]?

}

struct SpotUploadFeatureDTO: Encodable {

    let category: String

    let optionList: [String]

}
