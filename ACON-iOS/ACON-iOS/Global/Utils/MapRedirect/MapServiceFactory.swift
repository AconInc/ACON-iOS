//
//  MapServiceFactory.swift
//  ACON-iOS
//
//  Created by 김유림 on 6/6/25.
//

import Foundation

final class MapServiceFactory {

    static func createService(for type: MapType) -> MapServiceProtocol {
        switch type {
        case .naver:
            return NaverMapService()
        case .apple:
            return AppleMapService()
        }
    }

}
