//
//  SpotModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/12/25.
//

import UIKit

// MARK: - Spot

struct SpotModel: Equatable {

    let id: Int64

    let imageURL: String?

    let name: String

    let acornCount: Int

    let tagList: [SpotTagType]

    let eta: Int

    let latitude: Double

    let longitude: Double

}


// MARK: - Init from DTO

extension SpotModel {
    
    init(from dto: SpotDTO) {
        self.id = dto.id
        self.imageURL = dto.image
        self.name = dto.name
        self.acornCount = dto.acornCount

        let tagList = dto.tagList ?? []
        self.tagList = tagList.map { SpotTagType(rawValue: $0) }

        self.eta = dto.eta
        self.latitude = dto.latitude
        self.longitude = dto.longitude
    }
    
}
