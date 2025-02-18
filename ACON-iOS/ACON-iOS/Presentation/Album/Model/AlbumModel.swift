//
//  AlbumModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/12/25.
//

import UIKit
import Photos

struct ImageAsset: Equatable {
    
    let index: Int
    
    let asset: PHAsset
    
}

struct AlbumModel: Equatable {
    
    let localizedTitle: String
    
    let count: Int
    
    let thumbnailImage: UIImage
    
    var title: String {
        switch localizedTitle {
        case "Recents": return "최근 항목"
        case "Favorites": return "즐겨찾는 항목"
        case "Screenshots": return "스크린샷"
        default: return localizedTitle
        }
    }
    
    init(title: String, count: Int, thumbnailImage: UIImage) {
        self.localizedTitle = title
        self.count = count
        self.thumbnailImage = thumbnailImage
    }
    
}

struct PresignedURLModel: Equatable {
    
    var fileName: String
    
    var presignedURL: String
    
}
