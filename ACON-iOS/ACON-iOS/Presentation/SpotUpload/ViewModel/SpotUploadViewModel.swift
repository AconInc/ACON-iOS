//
//  SpotUploadViewModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/16/25.
//

import Foundation

final class SpotUploadViewModel {

    var isPreviousButtonEnabled: ObservablePattern<Bool> = ObservablePattern(nil)
    var isNextButtonEnabled: ObservablePattern<Bool> = ObservablePattern(nil)

    // TODO: 추후 수정
    var spotName: String? = nil
    var spotType: SpotType? = nil
    var restaurantFeature: Set<SpotUploadType.RestaurantOptionType> = []
    var recommendedMenu: String? = nil
    var valueRating: SpotUploadType.ValueRatingType? = nil

}
