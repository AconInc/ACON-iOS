//
//  SpotDetailModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/16/25.
//

import Foundation
import UIKit

struct SpotDetail: Equatable {
    
    let name: String
    
    let spotType: String
    
    let firstImageURL: String
    
    let openStatus: Bool
    
    let address: String
    
    let localAcornCount: Int
    
    let basicAcornCount: Int
    
    let latitude: Double
    
    let longitude: Double
    
    init(name: String, spotType: String, firstImageURL: String, openStatus: Bool, address: String, localAcornCount: Int, basicAcornCount: Int, latitude: Double, longitude: Double) {
        self.name = name
        self.spotType = spotType
        self.firstImageURL = firstImageURL
        self.openStatus = openStatus
        self.address = address
        self.localAcornCount = localAcornCount
        self.basicAcornCount = basicAcornCount
        self.latitude = latitude
        self.longitude = longitude
    }
    
}


struct SpotMenuInfo: Equatable {
    
    let menuID: Int
    
    let name: String
    
    let price: Int
    
    let imageURL: String
    
    init(menuID: Int, name: String, price: Int, imageURL: String) {
        self.menuID = menuID
        self.name = name
        self.price = price
        self.imageURL = imageURL
    }
    
}
