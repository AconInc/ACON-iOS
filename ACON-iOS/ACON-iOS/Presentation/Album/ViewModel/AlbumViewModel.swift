//
//  AlbumViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/9/25.
//

import Photos
import UIKit

class AlbumViewModel {

    // TODO: 메모리 최적화 처리
    // TODO: PhotoManager로 로직 모두 옮길 것
    var photosInCurrentAlbum = PHFetchResult<PHAsset>()
    
    var smartAlbums = [PHAssetCollection]()
    
    var userCreatedAlbums = PHFetchResult<PHAssetCollection>()
    
    let albumSubtypes: [PHAssetCollectionSubtype] = [.smartAlbumUserLibrary, .smartAlbumFavorites, .smartAlbumScreenshots]
    
    func requestAlbumPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    print("Album: 권한 허용")
                    completion(true)
                case .denied, .restricted, .notDetermined:
                    print("Album: 권한 거부")
                    completion(false)
                @unknown default:
                    print("Album: 알 수 없는 상태")
                    completion(false)
                }
            }
        }
    }
    
    // TODO: 사진 권한 관련 alert 적용
    private func checkPhotoLibraryAuthorization() -> Bool {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        return authStatus == .authorized || authStatus == .limited
    }

    /// 전체 앨범 가져오기
    func fetchAlbums() {
        guard checkPhotoLibraryAuthorization() else {
            requestAlbumPermission { granted in
                if granted {
                    self.fetchAlbums()
                }
            }
            return
        }
        
        for albumSubtype in albumSubtypes {
            if let smartAlbum = PHAssetCollection.fetchAssetCollections(
                with: .smartAlbum,
                subtype: albumSubtype,
                options: nil
            ).firstObject {
                smartAlbums.append(smartAlbum)
            }
        }
        
        let userCreatedAlbumsOptions = PHFetchOptions()
        /// 비어있지 않은 앨범만
        userCreatedAlbumsOptions.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        /// 사용자가 생성한 로컬 앨범들만 ( iCloud 공유 앨범 등 X)
        userCreatedAlbums = PHAssetCollection.fetchAssetCollections(with: .album,
                                                                    subtype: .albumRegular,
                                                                    options: userCreatedAlbumsOptions)
    }
    
    /// 앨범 전체 사진 가져오기  ( album 인자에 해당하는 앨범 입력, 미입력 시 전체 사진 불러옴)
    func fetchPhotos(in album: PHAssetCollection? = nil) {
        guard checkPhotoLibraryAuthorization() else {
            requestAlbumPermission { granted in
                if granted {
                    self.fetchAlbums()
                }
            }
            return
        }
        
        let fetchOptions = PHFetchOptions()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        if let album = album {
            photosInCurrentAlbum = PHAsset.fetchAssets(in: album, options: fetchOptions)
        } else {
            photosInCurrentAlbum = PHAsset.fetchAssets(with: fetchOptions)
        }
    }

    // TODO: - 추후 PhotoManager 등으로 리팩
    private let imageCache = NSCache<NSString, UIImage>()
    
    private var imageRequestIDs: [NSString: PHImageRequestID] = [:]

    func setImageCache(for asset: PHAsset,
                       size: CGSize,
                       completion: @escaping (UIImage?) -> Void) {
        let cacheKey = asset.localIdentifier as NSString
        
        /// 캐시된 이미지가 있다면 바로 반환
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        /// 이미지 요청 옵션
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.resizeMode = .exact
        options.version = .current
        
        /// 이미지 요청
        let requestID = PHImageManager.default().requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFill,
            options: options
        ) { [weak self] image, info in
            if let image = image {
                self?.imageCache.setObject(image, forKey: cacheKey)
                completion(image)
            } else {
                // TODO: - 이미지 로딩 실패 시 에러 처리
                print("image load failed")
            }
        }
        
        /// 요청 ID 저장
        imageRequestIDs[cacheKey] = requestID
    }

    func getCachedImage(for asset: PHAsset) -> UIImage? {
        let cacheKey = asset.localIdentifier as NSString
        return imageCache.object(forKey: cacheKey)
    }
    
    func cancelImageLoad(for asset: PHAsset, size: CGSize) {
        let key = asset.localIdentifier as NSString
        if let requestID = imageRequestIDs[key] {
            PHImageManager.default().cancelImageRequest(requestID)
            imageRequestIDs.removeValue(forKey: key)
        }
    }
    
    var fetchedImages: [ImageAsset] = []
    
    private var currentIndex = 0
    
    private let fetchLimit = 50

    private var isLoadingPhotos = false
    
    let onSuccessLoadImages: ObservablePattern<Bool> = ObservablePattern(nil)
    
    func loadPhotos(in album: PHAssetCollection? = nil,
                    thumbnailSize: CGSize,
                    completion: @escaping () -> Void) {
        guard checkPhotoLibraryAuthorization() else {
            requestAlbumPermission { granted in
                if granted {
                    self.fetchAlbums()
                }
            }
            return
        }

        guard !isLoadingPhotos else { return }
        isLoadingPhotos = true
        
        // 앨범이 비어있으면 먼저 가져오기
        if photosInCurrentAlbum.count == 0 {
            fetchPhotos(in: album)
        }
        
        let endIndex = min(currentIndex + fetchLimit, photosInCurrentAlbum.count)
        let indexSet = IndexSet(integersIn: currentIndex..<endIndex)
        
        let newAssets = indexSet.compactMap { index -> ImageAsset? in
            guard index < photosInCurrentAlbum.count else { return nil }
            let asset = photosInCurrentAlbum.object(at: index)
            return ImageAsset(index: index, asset: asset)
        }
        
        /// 모든 비동기 작업 수행 완료까지 기다리기
        let group = DispatchGroup()
        for imageAsset in newAssets {
            group.enter()
            setImageCache(for: imageAsset.asset, size: thumbnailSize) { _ in
                group.leave()
            }
        }
        
        /// 모든 썸네일 로딩 완료 시 호출
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.fetchedImages.append(contentsOf: newAssets)
            self.currentIndex += newAssets.count
            self.isLoadingPhotos = false
            self.onSuccessLoadImages.value = true
            completion()
        }
        
        func resetPhotoPagination() {
            currentIndex = 0
            fetchedImages.removeAll()
            isLoadingPhotos = false
        }
        
    }
}
