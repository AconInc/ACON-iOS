//
//  SpotListDTO.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/21/25.
//

import Foundation

struct PostSpotListRequest: Encodable {

    let latitude: Double

    let longitude: Double

    let condition: SpotConditionDTO

}

struct SpotConditionDTO: Encodable {

    let spotType: String

    let filterList: [SpotFilterDTO]?

}

struct SpotFilterDTO: Encodable {

    let category: String

    let optionList: [String]

}
