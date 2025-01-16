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
        case .nopo: return .nopo
        case .modern: return .mordern
        }
    }
    
    var mappedValue: String {
        switch self {
        case .nopo: return "TRADITIONAL"
        case .modern: return "MODERN"
        }
    }
    
}
