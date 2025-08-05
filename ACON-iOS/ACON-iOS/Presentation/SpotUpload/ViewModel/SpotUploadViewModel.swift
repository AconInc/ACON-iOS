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


    // MARK: - Network

    func postSpot() {
        let request = PostSpotUploadRequest(
            spotName: selectedSpot?.spotName ?? "",
            address: selectedSpot?.spotAddress ?? "",
            spotType: spotType?.serverKey ?? "",
            featureList: configureFeatureList(),
            recommendedMenu: recommendedMenu ?? "",
            imageList: presignedURLs.isEmpty ? nil : presignedURLs
        )

        ACService.shared.spotUploadService.postSpotUpload(requestBody: request) { [weak self] response in
            switch response {
            case .success(_):
                self?.onSuccessPostSpot.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postSpot()
                }
            default:
                self?.handleNetworkError { [weak self] in
                    self?.postSpot()
                }
            }
        }
    }
}


// MARK: - Helper

private extension SpotUploadViewModel {

    func configureFeatureList() -> [SpotUploadFeatureDTO] {
        guard let spotType else { return [] }

        var featureListDTO: [SpotUploadFeatureDTO] = []

        // NOTE: 식당 or 카페 feature
        switch spotType {
        case .restaurant:
            let restaurantFeature = SpotUploadFeatureDTO(
                category: SpotUploadType.restaurantFeature.serverKey,
                optionList: restaurantFeature.map { $0.serverKey }
            )
            featureListDTO.append(restaurantFeature)
        case .cafe:
            if (isWorkFriendly ?? false) {
                let cafeFeature = SpotUploadFeatureDTO(
                    category: SpotUploadType.cafeFeature.serverKey,
                    optionList: [SpotUploadType.CafeOptionType.workFriendly.serverKey]
                )
                featureListDTO.append(cafeFeature)
            }
        }

        // NOTE: 가성비
        let priceFeature = SpotUploadFeatureDTO(
            category: SpotUploadType.price.serverKey,
            optionList: [priceValue?.serverKey ?? ""]
        )
        featureListDTO.append(priceFeature)

        return featureListDTO
    }

}
