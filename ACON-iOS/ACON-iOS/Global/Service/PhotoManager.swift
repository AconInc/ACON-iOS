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
    case requestError(Error) // 4xx
    case serverError        // 5xx
    case networkError
    case decodingError
    case otherError

    var errorDescription: String? {
        switch self {
        case .imageDataConversionFailed: return "🎞️ Failed to retrieve image data."
        case .missingFileName: return "🎞️ Missing the filename of the photo."
        case .tokenExpired: return "🎞️ Authentication token has expired."
        case .requestError(let error): return "🎞️ A client error occurred: \(error.localizedDescription)"
        case .serverError: return "🎞️ The server is currently unavailable. Please try again later."
        case .networkError: return "🎞️ Please check your internet connection."
        case .decodingError: return "🎞️ Failed to process the response from the server."
        case .otherError: return "🎞️ Other error occurred."
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
        let (imageData, fileName) = try await processAsset(asset)
        let presignedURLResponse = try await requestPresignedUrl(fileName: fileName)
        try await uploadToS3(data: imageData, to: presignedURLResponse.preSignedUrl, fileName: fileName)

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
    func processAsset(_ asset: PHAsset) async throws -> (data: Data, fileName: String) {
        guard let originalFileName = getFileName(for: asset) else {
            throw PhotoManagerError.missingFileName
        }

        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        
        return try await withCheckedThrowingContinuation { continuation in
            PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) { [weak self] data, dataUTI, _, info in
                guard let self = self else {
                    continuation.resume(throwing: PhotoManagerError.imageDataConversionFailed)
                    return
                }

                if let error = info?[PHImageErrorKey] as? Error {
                    continuation.resume(throwing: error); return
                }

                guard let imageData = data,
                      let utiString = dataUTI as String? else {
                    continuation.resume(throwing: PhotoManagerError.imageDataConversionFailed)
                    return
                }

                let isFormatAllowed = self.imageType.allowedUTIs.contains(utiString)

                // NOTE: 허용하지 않는 포맷 -> jpeg로 변환
                if !isFormatAllowed {
                    print("🎞️ Format '\(utiString)' is not allowed. Converting to JPEG.")
                    guard let image = UIImage(data: imageData),
                          let jpegData = image.jpegData(compressionQuality: self.imageType.compressionQuality) else {
                        continuation.resume(throwing: PhotoManagerError.imageDataConversionFailed)
                        return
                    }
                    let newFileName = (originalFileName as NSString).deletingPathExtension + ".jpeg"
                    continuation.resume(returning: (data: jpegData, fileName: newFileName))

                // NOTE: 허용하는 포맷 -> 원본 데이터 반환
                } else {
                    continuation.resume(returning: (data: imageData, fileName: originalFileName))
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
                    continuation.resume(throwing: PhotoManagerError.requestError(errorResponse))
                case .serverErr:
                    continuation.resume(throwing: PhotoManagerError.serverError)
                case .networkFail:
                    continuation.resume(throwing: PhotoManagerError.networkError)
                case .decodedErr:
                    continuation.resume(throwing: PhotoManagerError.decodingError)
                default:
                    continuation.resume(throwing: PhotoManagerError.otherError)
                }
            }
        }
    }

    /// NOTE: S3에 사진 업로드
    func uploadToS3(data: Data, to urlString: String, fileName: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            imageService.putImageToPresignedURL(
                requestBody: PutImageToPresignedURLRequest(presignedURL: urlString,
                                                           imageData: data,
                                                           fileName: fileName)
            ) { result in
                switch result {
                case .success:
                    continuation.resume(returning: ())
                case .reIssueJWT:
                    continuation.resume(throwing: PhotoManagerError.tokenExpired)
                case .requestErr(let errorResponse):
                    continuation.resume(throwing: PhotoManagerError.requestError(errorResponse))
                case .serverErr:
                    continuation.resume(throwing: PhotoManagerError.serverError)
                case .networkFail:
                    continuation.resume(throwing: PhotoManagerError.networkError)
                case .decodedErr:
                    continuation.resume(throwing: PhotoManagerError.decodingError)
                default:
                    continuation.resume(throwing: PhotoManagerError.otherError)
                }
            }
        }
    }

}
