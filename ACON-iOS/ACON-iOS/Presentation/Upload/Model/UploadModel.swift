//
//  UploadModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import Foundation

struct SearchKeywordModel: Equatable {
    
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

struct SearchSuggestionModel: Equatable {
    
    let spotList: [String]
    
    init(spotList: [String]) {
        self.spotList = spotList
    }
    
}

struct VerifyReviewModel: Equatable {
    
    let spotID: Int
    
    let latitude: Double
    
    let logitude: Double
    
    init(spotID: Int, latitude: Double, logitude: Double) {
        self.spotID = spotID
        self.latitude = latitude
        self.logitude = logitude
    }
    
}


struct ReviewPostModel: Equatable {
    
    let spotID: Int
    
    let acornCount: Int
    
    init(spotID: Int, acornCount: Int) {
        self.spotID = spotID
        self.acornCount = acornCount
    }
    
}

struct AcornCountModel: Equatable {
    
    let acornCount: Int
    
    init(acornCount: Int) {
        self.acornCount = acornCount
    }
    
}
