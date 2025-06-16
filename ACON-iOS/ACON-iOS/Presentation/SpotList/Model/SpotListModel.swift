//
//  SpotModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/12/25.
//

import UIKit

// MARK: - Model

struct SpotListModel {

    let transportMode: TransportModeType?

    let spotList: [SpotModel]

}

struct SpotModel: Equatable {

    let spotId: Int64

    let imageURL: String?

    let name: String

    let acornCount: Int

    let tagList: [SpotTagType]

    let isOpen: Bool

    let closingTime: String

    let nextOpening: String

    let eta: Int

    let latitude: Double

    let longitude: Double

}


// MARK: - init

extension SpotListModel {

    init() {
        self.transportMode = nil
        self.spotList = []
    }

}


// MARK: - init from DTO

extension SpotListModel {

    init(from dto: PostSpotListResponse) {
        self.transportMode = TransportModeType(dto.transportMode)
        self.spotList = dto.spotList.map { SpotModel(from: $0) }
    }

}

extension SpotModel {

    init(from dto: SpotDTO) {
        self.spotId = dto.spotId
        self.imageURL = dto.image
        self.name = dto.name
        self.acornCount = dto.acornCount

        let tagList = dto.tagList ?? []
        self.tagList = tagList.map { SpotTagType(rawValue: $0) }

        self.isOpen = dto.isOpen
        self.closingTime = dto.closingTime
        self.nextOpening = dto.nextOpening

        self.eta = dto.eta
        self.latitude = dto.latitude
        self.longitude = dto.longitude
    }

}
