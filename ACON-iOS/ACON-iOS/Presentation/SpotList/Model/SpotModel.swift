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

    let tagList: [String]?

    let eta: Int

    let latitude: Double

    let longitude: Double

}
