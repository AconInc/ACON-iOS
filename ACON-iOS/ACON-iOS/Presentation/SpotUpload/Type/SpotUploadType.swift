//
//  SpotUploadType.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/24/25.
//

import Foundation


enum SpotUploadType {

    case restaurantFeature, cafeFeature, priceValue

    var serverKey: String {
        switch self {
        case .restaurantFeature: return "RESTAURANT_FEATURE"
        case .cafeFeature: return "CAFE_FEATURE"
        case .priceValue: return "PRICE"
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

    enum CafeOptionType: CaseIterable {

        case workFriendly, excludeFranchise

        var text: String {
            switch self {
            case .workFriendly: return "작업하기 좋은 곳"
            case .excludeFranchise: return "프랜차이즈 제외"
            }
        }

        var serverKey: String {
            switch self {
            case .workFriendly: return "WORK_FRIENDLY"
            case .excludeFranchise: return "EXCLUDE_FRANCHISE"
            }
        }

        init?(serverKey: String) {
            for option in SpotUploadType.CafeOptionType.allCases {
                if option.serverKey == serverKey {
                    self = option
                    return
                }
            }
            return nil
        }

    }


    // MARK: - Price

    enum ValueRatingType: CaseIterable {

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
            case .low: return "VALUE_FOR_MONEY"
            case .average: return "AVERAGE"
            case .best: return "VALUE_FOR_MONEY"
            }
        }

    }

}
