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
        case .nopo: return StringLiterals.FavoriteSpotStyles.nopo
        case .modern: return StringLiterals.FavoriteSpotStyles.modern
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
