//
//  SpotModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/12/25.
//

import UIKit

// MARK: - Spot

struct SpotModel: Equatable {
    
    let id: Int64
    
    let imageURL: String
    
    let matchingRate: Int?
    
    let type: SpotCategoryType
    
    let name: String
    
    let walkingTime: Int
    
}
