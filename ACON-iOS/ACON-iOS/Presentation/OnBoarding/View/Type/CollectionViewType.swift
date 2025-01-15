//
//  CollectionViewType.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/16/25.
//

import UIKit

enum CollectionViewType {
    case dislike
    case favoriteCuisine

    var itemCount: Int {
        switch self {
        case .dislike: return DislikeType.allCases.count
        case .favoriteCuisine: return FavoriteCuisineType.allCases.count
        }
    }

    func item(at index: Int) -> (name: String, image: UIImage?, mappedValue: String) {
        switch self {
        case .dislike:
            let option = DislikeType.allCases[index]
            return (option.name, option.image, option.mappedValue)
        case .favoriteCuisine:
            let option = FavoriteCuisineType.allCases[index]
            return (option.name, option.image, option.mappedValue)
        }
    }
}
