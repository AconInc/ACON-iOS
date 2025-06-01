//
//  SpotFilterType.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import Foundation

// MARK: - 필터 카테고리

enum SpotFilterType {

    case restaurantFeature, cafeFeature, openingHours, price

    var serverKey: String {
        switch self {
        case .restaurantFeature: return "RESTAURANT_FEATURE"
        case .cafeFeature: return "CAFE_FEATURE"
        case .openingHours: return "OPENING_HOURS"
        case .price: return "PRICE"
        }
    }

}


// MARK: - 필터 옵션

extension SpotFilterType {

    // MARK: - Restaurant
    
    enum RestaurantOptionType: CaseIterable {

        case korean, chinese, japanese, western, asian, fusion, koreanStreet, buffet, bar, excludeFranchise

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
            case .excludeFranchise: return "프랜차이즈 제외"
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
            case .excludeFranchise: return "EXCLUDE_FRANCHISE"
            }
        }

    }


    // MARK: - Cafe

    enum CafeOptionType: CaseIterable {

        case goodForWork, excludeFranchise

        var text: String {
            switch self {
            case .goodForWork: return "작업하기 좋은 곳"
            case .excludeFranchise: return "프랜차이즈 제외"
            }
        }

        var serverKey: String {
            switch self {
            case .goodForWork: return "WORK_FRIENDLY"
            case .excludeFranchise: return "EXCLUDE_FRANCHISE"
            }
        }

    }


    // MARK: - OpeningHours

    enum OpeningHoursOptionType: CaseIterable {

        case overMidnight, overTenPM
        
        var text: String {
            switch self {
            case .overMidnight: return "밤 12시 이후"
            case .overTenPM: return "밤 10시 이후"
            }
        }

        var serverKey: String {
            switch self {
            case .overMidnight: return "OPEN_AFTER_MIDNIGHT"
            case .overTenPM: return "OPEN_AFTER_10PM"
            }
        }

    }


    // MARK: - Price

    enum PriceOptionType: CaseIterable {

        case goodPrice

        var text: String {
            switch self {
            case .goodPrice: return StringLiterals.SpotListFilter.goodPricePlace
            }
        }

        var serverKey: String {
            switch self {
            case .goodPrice: return "VALUE_FOR_MONEY"
            }
        }
    }

}
