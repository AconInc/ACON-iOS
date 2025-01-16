//
//  FavoriteSpotType.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/16/25.
//

import UIKit

enum FavoriteSpotType: CaseIterable {
    
    case restaurant
    case cafe
    
    var name: String {
        switch self {
        case .restaurant: return "음식점"
        case .cafe: return "카페"
        }
    }
    
    var image: UIImage {
        switch self {
        case .restaurant: return UIImage(named: "restaurant") ?? UIImage(systemName: "photo")!
        case .cafe: return UIImage(named: "cafe") ?? UIImage(systemName: "photo")!
        }
    }
    
    var mappedValue: String {
        switch self {
        case .restaurant: return "RESTAURANT"
        case .cafe: return "CAFE"
        }
    }
}
