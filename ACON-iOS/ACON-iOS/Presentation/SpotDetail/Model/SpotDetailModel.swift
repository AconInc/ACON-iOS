//
//  SpotDetailModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/16/25.
//

import Foundation
import UIKit

struct SpotDetail: Equatable {
    
    let firstImageURL: String
    
    let isOpen: Bool
    
    let address: String
    
    let localAcornCount: Int
    
    let basicAcornCount: Int
    
    init(firstImageURL: String, isOpen: Bool, address: String, localAcornCount: Int, basicAcornCount: Int) {
        self.firstImageURL = firstImageURL
        self.isOpen = isOpen
        self.address = address
        self.localAcornCount = localAcornCount
        self.basicAcornCount = basicAcornCount
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
