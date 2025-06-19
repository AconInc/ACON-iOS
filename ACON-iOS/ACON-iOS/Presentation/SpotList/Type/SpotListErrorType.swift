//
//  SpotListErrorType.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/21/25.
//

import Foundation

enum SpotListErrorType {
    
    case emptyList, unsupportedRegion, needLoginToSeeMore
    
    var errorMessage: String {
        switch self {
        case .emptyList: return StringLiterals.SpotList.emptySpotListErrorMessage
        case .unsupportedRegion: return StringLiterals.SpotList.unsupportedRegionPleaseRetry
        case .needLoginToSeeMore: return StringLiterals.SpotList.needLoginToSeeMore
        }
    }
    
}
