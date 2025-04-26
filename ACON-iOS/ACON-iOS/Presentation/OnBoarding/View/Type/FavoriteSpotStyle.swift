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
        case .nopo: return .imgNopo
        case .modern: return .imgMordern
        }
    }
    
    var mappedValue: String {
        switch self {
        case .nopo: return "VINTAGE"
        case .modern: return "MODERN"
        }
    }
    
}
