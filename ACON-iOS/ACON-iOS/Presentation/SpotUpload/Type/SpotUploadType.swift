//
//  SpotUploadType.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/24/25.
//

import Foundation


enum SpotUploadType {

    case restaurantFeature, cafeFeature, price

    var serverKey: String {
        switch self {
        case .restaurantFeature: return "RESTAURANT_FEATURE"
        case .cafeFeature: return "CAFE_FEATURE"
        case .price: return "PRICE"
        }
    }

}


// MARK: - 필터 옵션

extension SpotUploadType {

    // MARK: - Restaurant

    enum RestaurantOptionType: CaseIterable {

        case korean, chinese, japanese, western, asian, fusion, koreanStreet, buffet, bar, others

        var text: String {
            switch self {
            case .korean: return "한식"
            case .chinese: return "중식"
            case .japanese: return "일식"
            case .western: return "양식"
            case .asian: return "아시안"
            case .fusion: return "퓨전"
            case .koreanStreet: return "분식"
            case .buffet: return "뷔페"
            case .bar: return "술/bar"
            case .others: return "기타"
            }
        }

        var serverKey: String {
            switch self {
            case .korean: return "KOREAN"
            case .chinese: return "CHINESE"
            case .japanese: return "JAPANESE"
            case .western: return "WESTERN"
            case .asian: return "SOUTHEAST_ASIAN"
            case .fusion: return "FUSION"
            case .koreanStreet: return "BUNSIK"
            case .buffet: return "BUFFET"
            case .bar: return "DRINKING_PLACE"
            case .others: return "OTHERS" // TODO: 서버 명세 확인
            }
        }

        init?(serverKey: String) {
            for option in SpotUploadType.RestaurantOptionType.allCases {
                if option.serverKey == serverKey {
                    self = option
                    return
                }
            }
            return nil
        }

    }


    // MARK: - Cafe

    enum CafeOptionType {

        case workFriendly

        var text: String {
            switch self {
            case .workFriendly: return StringLiterals.SpotUpload.workFriendly
            }
        }

        var serverKey: String {
            switch self {
            case .workFriendly: return "WORK_FRIENDLY"
            }
        }

    }


    // MARK: - Price

    enum PriceValueType: CaseIterable {

        case low, average, best

        var text: String {
            switch self {
            case .low: return StringLiterals.SpotUpload.lowValue
            case .average: return StringLiterals.SpotUpload.averageValue
            case .best: return StringLiterals.SpotUpload.bestValue
            }
        }

        var serverKey: String {
            switch self {
            case .low: return "LOW_VALUE"
            case .average: return "AVERAGE_VALUE"
            case .best: return "VALUE_FOR_MONEY"
            }
        }

    }

}
