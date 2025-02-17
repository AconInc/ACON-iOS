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
    
    var selectedAlbumIndex: Int = 0
    
    var photosInCurrentAlbum = PHFetchResult<PHAsset>()
    
    var fetchedAlbumIndex: ObservablePattern<Int> = ObservablePattern(nil)
    
    // MARK: - 사진 권한 요청
    
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
    
    
    // MARK: - 앨범 가져오기
    
    var albums = [PHAssetCollection]()
    
    var albumInfo = [AlbumModel]()
    
    let albumSubtypes: [PHAssetCollectionSubtype] = [.smartAlbumUserLibrary,
                                                     .smartAlbumFavorites,
                                                     .smartAlbumScreenshots]
    
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
        
        /// 기존 앨범 초기화
        albums.removeAll()
        albumInfo.removeAll()
        
        /// 스마트앨범
        for albumSubtype in albumSubtypes {
            if let smartAlbum = PHAssetCollection.fetchAssetCollections(
                with: .smartAlbum,
                subtype: albumSubtype,
                options: nil
            ).firstObject {
                albums.append(smartAlbum)
            }
        }
        
        /// 사용자 생성 앨범
        let userCreatedAlbumsOptions = PHFetchOptions()
        userCreatedAlbumsOptions.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        let sortDescriptor = NSSortDescriptor(key: "startDate", ascending: false)
        userCreatedAlbumsOptions.sortDescriptors = [sortDescriptor]
        
        let userAlbums = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .albumRegular,
            options: userCreatedAlbumsOptions
        )
        
        userAlbums.enumerateObjects { [weak self] album, _, _ in
            self?.albums.append(album)
        }
        
        /// 로딩 전 띄워주는 스켈레톤 모델
        /// albumInfo 호출은 비동기, 화면 테이블뷰는 순서를 지켜서 띄워야 함 -> albumInfo에 append하는 것이 아닌, albumInfo를 스켈레톤으로 채운 뒤 로드 완료되면 교체
        let skeletonAlbumModel = AlbumModel(title: "",
                                            count: -1,
                                            thumbnailImage: UIImage.skeletonEmptyAlbum)
        albumInfo = Array(repeating: skeletonAlbumModel, count: albums.count)
        
        for (index, album) in albums.enumerated() {
            loadAlbumInfo(album, at: index)
        }
    }
    
    private func loadAlbumInfo(_ album: PHAssetCollection, at index: Int) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            let fetchResult = PHAsset.fetchAssets(in: album, options: fetchOptions)
            guard fetchResult.count > 0 else { return }
            
            var albumThumbnail: UIImage = .imgProfileBasic80
            if let firstAsset = fetchResult.lastObject {
                let options = PHImageRequestOptions()
                options.deliveryMode = .fastFormat
                options.isNetworkAccessAllowed = true
                options.isSynchronous = true
                
                PHImageManager.default().requestImage(
                    for: firstAsset,
                    targetSize: CGSize(width: 100, height: 100),
                    contentMode: .aspectFill,
                    options: options
                ) { image, _ in
                    albumThumbnail = image ?? .imgProfileBasic80
                }
            }
            
            let albumModel = AlbumModel(
                title: album.localizedTitle ?? "앨범",
                count: fetchResult.count,
                thumbnailImage: albumThumbnail
            )
            
            DispatchQueue.main.async { [weak self] in
                self?.albumInfo[index] = albumModel
                self?.fetchedAlbumIndex.value = index
            }
        }
    }
    
    // MARK: - 사진 가져오기

    /// 앨범 전체 사진 (이미지만, 영상 X)가져오기  ( album 인자에 해당하는 앨범 입력, 미입력 시 전체 사진 불러옴)
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
        /// 이미지만 가져오기
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
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
    
    private var isFirstLoad = true
    
    let onSuccessLoadImages: ObservablePattern<Bool> = ObservablePattern(nil)
    
    func loadPhotos(in album: PHAssetCollection? = nil,
                    thumbnailSize: CGSize,
                    completion: @escaping () -> Void) {
        guard checkPhotoLibraryAuthorization() else {
            requestAlbumPermission { granted in
                if granted {
                    self.fetchPhotos(in: album)
                }
            }
            return
        }
        
        guard !isLoadingPhotos else { return }
        isLoadingPhotos = true
        
        /// 새로운 앨범을 처음 로드하는 경우
        if isFirstLoad {
            fetchPhotos(in: album)
            isFirstLoad = false
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
    }
        
    func resetPhotoPagination() {
        currentIndex = 0
        isFirstLoad = true
        fetchedImages.removeAll()
        isLoadingPhotos = false
    }
    
    
    // MARK: - 고화질 이미지 가져오기
    
    func getHighQualityImage(index: Int, completion: @escaping (UIImage) -> Void) {
        let asset = fetchedImages[index].asset
        /// 이미지 원본 크기
        let pixelSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.resizeMode = .exact
        options.version = .current
        
        /// 이미지 요청
        let requestID = PHImageManager.default().requestImage(
            for: asset,
            targetSize: pixelSize,
            contentMode: .aspectFill,
            options: options
        ) { [weak self] image, info in
            if image == nil {
                    print("Failed to load image. Info:", info ?? [:])
                }
            if let image = image {
                print("Loaded image size:", image.size)
                completion(image)
            } else {
                completion(.imgProfileBasic80)
                // TODO: - 이미지 로딩 실패 시 에러 처리
                print("high quality image load failed")
            }
        }
    }
    
}
