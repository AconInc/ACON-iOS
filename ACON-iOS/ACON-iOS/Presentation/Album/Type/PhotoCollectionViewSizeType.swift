//
//  PhotoCollectionViewSizeType.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/14/25.
//

import Foundation

enum PhotoCollectionViewSizeType {
    
    case cellWidth
    case cellSize
    case thumbnailSize
    
    var value: CGSize {
        switch self {
        case .cellWidth:
            let width = CGFloat((ScreenUtils.width - 12) / 4)
            return CGSize(width: width, height: width)
        case .cellSize:
            let width = PhotoCollectionViewSizeType.cellWidth.value.width
            return CGSize(width: width, height: width)
        case .thumbnailSize:
            return CGSize(width: 300, height: 300)
        }
    }
    
}


