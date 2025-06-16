//
//  SpotDetailModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/16/25.
//

import Foundation

struct SpotDetailInfoModel: Equatable {

    let spotID: Int64

    let imageURLs: [String]?

    let name: String

    let acornCount: Int

    let tagList: [SpotTagType]?

    let isOpen: Bool

    let closingTime: String

    let nextOpening: String

    let hasMenuboardImage: Bool

    let isSaved: Bool

    let signatureMenuList: [SignatureMenuModel]

    let latitude: Double

    let longitude: Double

}

struct SignatureMenuModel: Equatable {

    let name: String

    let price: Int

}


// MARK: - Init from DTO (+ tagList)

extension SpotDetailInfoModel {

    init(from dto: GetSpotDetailResponse) {
        self.spotID = dto.spotId
        self.imageURLs = dto.imageList
        self.name = dto.name
        self.acornCount = dto.acornCount
        self.tagList = dto.tagList?.map { SpotTagType(rawValue: $0) }
        
        self.isOpen = dto.isOpen
        self.closingTime = dto.closingTime
        self.nextOpening = dto.nextOpening
        self.hasMenuboardImage = dto.hasMenuboardImage
        self.isSaved = dto.isSaved

        let menuList = dto.signatureMenuList ?? []
        self.signatureMenuList = menuList.map { SignatureMenuModel(from: $0) }

        self.latitude = dto.latitude
        self.longitude = dto.longitude
    }

}

extension SignatureMenuModel {

    init(from dto: SignatureMenuDTO) {
        self.name = dto.name
        self.price = dto.price
    }

}
