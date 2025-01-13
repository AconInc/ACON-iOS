//
//  UploadModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import Foundation

struct RelatedSearchModel: Equatable {
    
    let spotID: Int
    
    let spotName: String
    
    let spotAddress: String
    
    let spotType: String
    
    init(spotID: Int,
         spotName: String,
         spotAddress: String,
         spotType: String) {
        self.spotID = spotID
        self.spotName = spotName
        self.spotAddress = spotAddress
        self.spotType = spotType
    }
    
}
