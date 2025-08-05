//
//  SpotUploadViewModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/16/25.
//

import UIKit

final class SpotUploadViewModel: Serviceable {

    // NOTE: 이전/다음 버튼
    let isPreviousButtonEnabled: ObservablePattern<Bool> = ObservablePattern(nil)
    let isNextButtonEnabled: ObservablePattern<Bool> = ObservablePattern(nil)

    // NOTE: 네트워크
    var onSuccessPostSpot: ObservablePattern<Bool> = ObservablePattern(nil)

    // NOTE: 장소 업로드 데이터
    var selectedSpot: SearchKeywordModel? = nil
    var spotType: SpotType? = nil
    var restaurantFeature: Set<SpotUploadType.RestaurantOptionType> = []
    var recommendedMenu: String? = nil
    var priceValue: SpotUploadType.PriceValueType? = nil

    var photos: [UIImage] = []
    let photosToAppend: ObservablePattern<[UIImage]> = ObservablePattern(nil)
    var presignedURLs: [String] = []
    
    var isWorkFriendly: Bool? = nil

}
