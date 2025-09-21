//
//  PhotoManager.swift
//  ACON-iOS
//
//  Created by 김유림 on 9/20/25.
//

import UIKit
import Photos

// MARK: - PhotoManager Errors

enum PhotoManagerError: LocalizedError {
    case imageDataConversionFailed
    case missingFileName
    case tokenExpired
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .imageDataConversionFailed: return "🎞️ Failed to retrieve image data."
        case .missingFileName: return "🎞️ Missing the filename of the photo."
        case .tokenExpired: return "🎞️ Authentication token has expired."
        case .networkError(let error): return "🎞️ Network error occurred: \(error.localizedDescription)"
        }
    }
}


// MARK: - PhotoManager

class PhotoManager {

    private let imageService: ImageServiceProtocol
    private let imageType: ImageType

    init(imageType: ImageType, imageService: ImageServiceProtocol = ACService.shared.imageService) {
        self.imageType = imageType
        self.imageService = imageService
    }

    // NOTE: 이미지 1개 업로드
    func uploadImage(asset: PHAsset) async throws -> String {
        guard let fileName = getFileName(for: asset) else {
            throw PhotoManagerError.missingFileName
        }

        let imageData = try await requestImageData(for: asset)
        let presignedURLResponse = try await requestPresignedUrl(fileName: fileName)
        try await uploadToS3(data: imageData, to: presignedURLResponse.preSignedUrl)

        return presignedURLResponse.fileUrl
    }

    // NOTE: 이미지 여러장 업로드
    func uploadImages(assets: [PHAsset]) async throws -> [String] {
        return try await withThrowingTaskGroup(of: String.self) { group in // NOTE: 병렬 작업
            var uploadedFileUrls: [String] = []
            uploadedFileUrls.reserveCapacity(assets.count) // array allocation
            
            for asset in assets {
                group.addTask {
                    return try await self.uploadImage(asset: asset)
                }
            }

            for try await fileUrl in group {
                uploadedFileUrls.append(fileUrl)
            }

            return uploadedFileUrls
        }
    }

}


// MARK: - Helper

private extension PhotoManager {

    /// NOTE: 사진 fileName 가져오기
    func getFileName(for asset: PHAsset) -> String? {
        return PHAssetResource.assetResources(for: asset).first?.originalFilename
    }

    /// NOTE: 사진을 데이터 타입으로 변환
    /// - `SPOT`: jpg, jpeg, webp, heic
    /// - `PROFILE`, `MENUBOARD`: jpg, jpeg, png, webp, heic
    private func requestImageData(for asset: PHAsset) async throws -> Data {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true

        return try await withCheckedThrowingContinuation { continuation in
            PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) { [weak self] data, dataUTI, _, info in
                guard let self = self else {
                    continuation.resume(throwing: PhotoManagerError.imageDataConversionFailed)
                    return
                }

                if let error = info?[PHImageErrorKey] as? Error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let imageData = data,
                      let utiString = dataUTI as String? else {
                    continuation.resume(throwing: PhotoManagerError.imageDataConversionFailed)
                    return
                }

                // NOTE: 허용하지 않는 포맷 -> jpeg로 변환
                let allowedFormats = self.imageType.allowedUTIs
                if !allowedFormats.contains(utiString) {
                    print("🎞️ Format '\(utiString)' is not allowed. Convert to JPEG")

                    guard let image = UIImage(data: imageData),
                          let jpegData = image.jpegData(compressionQuality: self.imageType.compressionQuality) else {
                        continuation.resume(throwing: PhotoManagerError.imageDataConversionFailed)
                        return
                    }
                    continuation.resume(returning: jpegData)
                } else {
                    // NOTE: 허용하는 포맷 -> 원본 데이터 반환
                    continuation.resume(returning: imageData)
                }
            }
        }
    }

    /// NOTE: PresignedURL 생성
    func requestPresignedUrl(fileName: String) async throws -> PostPresignedURLResponse {
        try await withCheckedThrowingContinuation { continuation in
            imageService.getPresignedURL(
                parameter: PostPresignedURLRequest(imageType: imageType.rawValue, originalFileName: fileName)
            ) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .reIssueJWT:
                    continuation.resume(throwing: PhotoManagerError.tokenExpired)
                case .requestErr(let errorResponse):
                    continuation.resume(throwing: errorResponse)
                case .decodedErr, .pathErr, .serverErr, .networkFail, .naverAPIErr:
                    let genericError = PhotoManagerError.networkError(
                        NSError(domain: "NetworkResultError", code: 0, userInfo: [NSLocalizedDescriptionKey: "‼️A server or network error occurred."])
                    )
                    continuation.resume(throwing: genericError)
                }
            }
        }
    }

    /// NOTE: S3에 사진 업로드
    func uploadToS3(data: Data, to urlString: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            imageService.putImageToPresignedURL(
                requestBody: PutImageToPresignedURLRequest(presignedURL: urlString, imageData: data)
            ) { result in
                switch result {
                case .success:
                    continuation.resume(returning: ())
                case .reIssueJWT:
                    continuation.resume(throwing: PhotoManagerError.tokenExpired)
                case .requestErr(let errorResponse):
                    continuation.resume(throwing: errorResponse)
                case .decodedErr, .pathErr, .serverErr, .networkFail, .naverAPIErr:
                    let genericError = PhotoManagerError.networkError(
                        NSError(domain: "NetworkResultError", code: 0, userInfo: [NSLocalizedDescriptionKey: "‼️A server or network error occurred during upload."])
                    )
                    continuation.resume(throwing: genericError)
                }
            }
        }
    }

}
