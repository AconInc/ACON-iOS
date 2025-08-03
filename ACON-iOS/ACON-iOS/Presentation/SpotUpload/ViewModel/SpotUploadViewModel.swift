//
//  SpotUploadViewModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/16/25.
//

import UIKit

final class SpotUploadViewModel {

    var isPreviousButtonEnabled: ObservablePattern<Bool> = ObservablePattern(nil)
    var isNextButtonEnabled: ObservablePattern<Bool> = ObservablePattern(nil)

    // TODO: 추후 수정
    var spotName: String? = nil
    var spotType: SpotType? = nil
    var restaurantFeature: Set<SpotUploadType.RestaurantOptionType> = []
    var recommendedMenu: String? = nil
    var valueRating: SpotUploadType.ValueRatingType? = nil

    var photos: [UIImage] = []
    var photosToAppend: ObservablePattern<[UIImage]> = ObservablePattern(nil)
    
    var isWorkFriendly: Bool? = nil

}
