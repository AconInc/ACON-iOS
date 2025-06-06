//
//  MapType.swift
//  ACON-iOS
//
//  Created by 김유림 on 6/6/25.
//

import Foundation

enum MapType {

    case naver
    case apple

    var service: MapServiceProtocol {
        switch self {
        case .naver: return NaverMapService()
        case .apple: return AppleMapService()
        }
    }

}
