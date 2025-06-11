//
//  SpotGradientType.swift
//  ACON-iOS
//
//  Created by 김유림 on 6/10/25.
//

import UIKit

enum SpotImageStatusType {

    case loading
    case loaded
    case loadFailed
    case noImageStatic
    case noImageDynamic(id: Int)

    var description: String {
        switch self {
        case .loading, .loaded:
            return ""
        case .loadFailed:
            return StringLiterals.SpotList.imageLoadingFailed
        case .noImageStatic:
            return StringLiterals.SpotList.preparingImage
        case .noImageDynamic(let id):
            return [StringLiterals.SpotList.noImageButAconGuarantees,
                    StringLiterals.SpotList.mysteryPlaceNoImage,
                    StringLiterals.SpotList.exploreToDiscover][id % 3]
        }
    }

}
