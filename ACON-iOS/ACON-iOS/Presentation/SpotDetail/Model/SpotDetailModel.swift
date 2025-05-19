//
//  SpotDetailModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/16/25.
//


import Foundation
import UIKit

struct SpotDetailInfoModel: Equatable {

    let spotID: Int64

    let imageURLs: [String]

    let name: String

    let acornCount: Int

    let hasMenuboardImage: Bool

    let signatureMenuList: [SignatureMenuModel]

    let latitude: Double

    let longitude: Double

    let tagList: [SpotTagType]

}

struct SignatureMenuModel: Equatable {

    let name: String

    let price: Int

}


// MARK: - Init from DTO (+ tagList)

extension SpotDetailInfoModel {

    init(from dto: GetSpotDetailResponse, tagList: [SpotTagType]) {
        self.spotID = dto.id
        self.imageURLs = dto.imageList
        self.name = dto.name
        self.acornCount = dto.acornCount
        self.hasMenuboardImage = dto.hasMenuboardImage

        let menuList = dto.signatureMenuList ?? []
        self.signatureMenuList = menuList.map { SignatureMenuModel(from: $0) }

        self.latitude = dto.latitude
        self.longitude = dto.longitude

        self.tagList = tagList
    }

}

extension SignatureMenuModel {

    init(from dto: SignatureMenuDTO) {
        self.name = dto.name
        self.price = dto.price
    }

}
