//
//  SpotListErrorType.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/21/25.
//

import Foundation

enum SpotListErrorType {
    
    case emptyList, unsupportedRegion, networkFail
    
    var errorMessage: String {
        switch self {
        case .emptyList: return StringLiterals.SpotList.emptySpotListErrorMessage
        case .unsupportedRegion: return StringLiterals.SpotList.unsupportedRegionErrorMessage
        case .networkFail: return "추천 장소를 확인할 수 없습니다." // TODO: 기획 확인
        }
    }
    
}
