//
//  AlbumModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/12/25.
//

import Foundation
import Photos

struct ImageAsset: Equatable {
    
    let index: Int
    
    let asset: PHAsset
    
    init(index: Int, asset: PHAsset) {
        self.index = index
        self.asset = asset
    }
    
}
