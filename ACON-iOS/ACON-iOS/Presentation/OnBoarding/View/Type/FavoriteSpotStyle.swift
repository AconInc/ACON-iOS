//
//  FavoriteSpotStyle.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/16/25.
//

import UIKit

enum FavoriteSpotStyle: CaseIterable {
    
    case nopo
    case modern
    
    var name: String {
        switch self {
        case .nopo: return "노포"
        case .modern: return "모던"
        }
    }
    
    var image: UIImage {
        switch self {
        case .nopo: return UIImage(named: "nopo") ?? UIImage(systemName: "photo")!
        case .modern: return UIImage(named: "mordern") ?? UIImage(systemName: "photo")!
        }
    }
    
    var mappedValue: String {
        switch self {
        case .nopo: return "TRADITIONAL"
        case .modern: return "MODERN"
        }
    }
}
