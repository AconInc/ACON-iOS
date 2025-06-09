//
//  SpotGradientType.swift
//  ACON-iOS
//
//  Created by 김유림 on 6/10/25.
//

import UIKit

enum SpotImageStatusType {

    case noImageStatic
    case noImageDynamic(id: Int)
    case loadFailed
    case loaded

    var description: String {
        switch self {
        case .noImageStatic:
            return StringLiterals.SpotList.preparingImage
        case .noImageDynamic(let id):
            return [StringLiterals.SpotList.noImageButAconGuarantees,
                    StringLiterals.SpotList.mysteryPlaceNoImage,
                    StringLiterals.SpotList.exploreToDiscover][id % 3]
        case .loadFailed:
            return StringLiterals.SpotList.imageLoadFailed
        case .loaded:
            return ""
        }
    }

}
