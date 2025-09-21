//
//  SpotUploadViewModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/16/25.
//

import UIKit
import Photos

final class SpotUploadViewModel: Serviceable {

    // MARK: - Properties

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

    var photosToAppend: ObservablePattern<[PhotoModel]> = ObservablePattern(nil)
    var photos: [PhotoModel] = []

    var isWorkFriendly: Bool? = nil

    // NOTE: 서버 오류로 401 뜰 때 재시도 루프에 빠지는 문제 방지
    private var uploadRetryCount = 0
    private let maxUploadRetries = 1


    // MARK: - Methods

    func uploadSpot() {
        self.uploadRetryCount = 0
        executeUploadFlow()
    }

    private func executeUploadFlow() {
        print("Spot upload attempt #\(uploadRetryCount + 1)")

        guard !photos.isEmpty else {
            postSpot(imageURLs: [])
            return
        }

        Task {
            do {
                let imageURLs = try await uploadSpotPhotos(assets: self.photos.map { $0.asset })
                postSpot(imageURLs: imageURLs)
            } catch PhotoManagerError.tokenExpired {
                guard self.uploadRetryCount < self.maxUploadRetries else {
                    print("🚨 Max retries reached. Stopping the loop.")
                    onSuccessPostSpot.value = false
                    return
                }

                self.uploadRetryCount += 1
                handleReissue { [weak self] in
                    self?.executeUploadFlow()
                }
            } catch {
                handleNetworkError { [weak self] in
                    self?.executeUploadFlow()
                }
                print("❌ A failure occurred during the upload process: \(error.localizedDescription)")
            }
        }
    }

}


// MARK: - Network Helpers

private extension SpotUploadViewModel {

    func uploadSpotPhotos(assets: [PHAsset]) async throws -> [String] {
        return try await PhotoManager(imageType: .SPOT).uploadImages(assets: assets)
    }

    func postSpot(imageURLs: [String]) {
        let request = PostSpotUploadRequest(
            spotName: selectedSpot?.spotName ?? "",
            address: selectedSpot?.spotAddress ?? "",
            spotType: spotType?.serverKey ?? "",
            featureList: configureFeatureList(),
            recommendedMenu: recommendedMenu ?? "",
            imageList: imageURLs.isEmpty ? nil : imageURLs
        )

        ACService.shared.spotUploadService.postSpotUpload(requestBody: request) { [weak self] response in
            switch response {
            case .success:
                self?.onSuccessPostSpot.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postSpot(imageURLs: imageURLs)
                }
            default:
                self?.handleNetworkError { [weak self] in
                    self?.postSpot(imageURLs: imageURLs)
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
