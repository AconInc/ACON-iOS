//
//  SpotListFilterModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import Foundation

struct SpotConditionModel: Equatable {
    
    let spotType: SpotType
    
    let filterList: [SpotFilterListModel]
    
    let walkingTime: Int
    
    let priceRange: Int
    
}

struct SpotFilterListModel: Equatable {
    
    let category: SpotType.FilterCategoryType
    
    let optionList: [String]
    
}
