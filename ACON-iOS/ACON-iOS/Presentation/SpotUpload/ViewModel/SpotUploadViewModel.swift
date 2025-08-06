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

    var isWorkFriendly: Bool? = nil

    private var photoPresignedURLInfos: [PresignedURLModel] = []
    private var photoPresignedURLResults: [Int: Bool] = [:] // NOTE: [photo index : result]


    // MARK: - Network

    func uploadSpot() {
        if photos.isEmpty {
            postSpot()
        } else {
            getPresignedURLs()
        }
    }

    private func postSpot() {
        let request = PostSpotUploadRequest(
            spotName: selectedSpot?.spotName ?? "",
            address: selectedSpot?.spotAddress ?? "",
            spotType: spotType?.serverKey ?? "",
            featureList: configureFeatureList(),
            recommendedMenu: recommendedMenu ?? "",
            imageList: photoPresignedURLInfos.isEmpty ? nil : photoPresignedURLInfos.map { $0.fileName }
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

    private func getPresignedURLs() {
        guard !photos.isEmpty else {
            postSpot()
            return
        }

        photoPresignedURLInfos.removeAll()

        let dispatchGroup = DispatchGroup()
        
        for i in 0..<photos.count {
            dispatchGroup.enter()

            photoPresignedURLResults[i] = false

            ACService.shared.imageService.getPresignedURL(
                parameter: GetPresignedURLRequest(imageType: ImageType.APPLY_SPOT.rawValue)
            ) { [weak self] response in
                defer { dispatchGroup.leave() }

                guard let self = self else { return }
                
                switch response {
                case .success(let data):
                    self.photoPresignedURLInfos.append(PresignedURLModel(fileName: data.fileName, presignedURL: data.preSignedUrl))
                    self.photoPresignedURLResults[i] = true
                case .reIssueJWT:
                    self.handleReissue { [weak self] in
                        self?.getPresignedURLs()
                    }
                default:
                    self.handleNetworkError { [weak self] in
                        self?.getPresignedURLs()
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            let allSuccess = self?.photoPresignedURLResults.allSatisfy { $0.value } ?? false
            if allSuccess {
                self?.putPhotosToPresignedURL()
            } else {
                self?.onSuccessPostSpot.value = false
            }
        }
    }

    private func putPhotosToPresignedURL() {
        // NOTE: `getPresignedURL`에서 handleNetworkError로 처리되기 때문에 count가 다를 가능성 적음
        // 다만, 예외적인 상황을 위해 방어 로직으로 추가함
        guard photoPresignedURLInfos.count == photos.count else {
            onSuccessPostSpot.value = false
            return
        }

        let dispatchGroup = DispatchGroup()

        for (index, photo) in photos.enumerated() {
            guard (photoPresignedURLResults[index] ?? false) else {
                print("❌ presignedURL 없음 at: \(index)")
                continue
            }

            guard let imageData = photo.jpegData(compressionQuality: 1) else {
                print("❌ 이미지 데이터 변환 실패 at: \(index)")
                continue
            }

            dispatchGroup.enter()

            let request = PutImageToPresignedURLRequest(
                presignedURL: photoPresignedURLInfos[index].presignedURL,
                imageData: imageData
            )

            ACService.shared.imageService.putImageToPresignedURL(requestBody: request) { [weak self] response in
                defer { dispatchGroup.leave() }
                guard let self = self else { return }
                
                switch response {
                case .success(_):
                    photoPresignedURLResults[index] = true
                case .reIssueJWT:
                    photoPresignedURLResults[index] = false
                    self.handleReissue {
                        self.putPhotosToPresignedURL()
                    }
                default:
                    photoPresignedURLResults[index] = false
                    self.handleNetworkError {
                        self.putPhotosToPresignedURL()
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            let allSuccess = self?.photoPresignedURLResults.allSatisfy { $0.value } ?? false
            if allSuccess {
                self?.postSpot()
            } else {
                self?.onSuccessPostSpot.value = false
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
