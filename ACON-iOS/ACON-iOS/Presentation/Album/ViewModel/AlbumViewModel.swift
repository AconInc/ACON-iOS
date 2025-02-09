//
//  AlbumViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/9/25.
//

import Photos
import UIKit

class AlbumViewModel {

    var photosInCurrentAlbum = PHFetchResult<PHAsset>()
    
    var smartAlbums = [PHAssetCollection]()
    
    var userCreatedAlbums = PHFetchResult<PHAssetCollection>()
    
    let albumSubtypes: [PHAssetCollectionSubtype] = [.smartAlbumUserLibrary, .smartAlbumFavorites, .smartAlbumScreenshots]
    

    func fetchAlbums() {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        guard authStatus ==  .authorized || authStatus == .limited else { return }
        
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
    
    func fetchPhotos(in album: PHAssetCollection? = nil) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        guard authStatus ==  .authorized || authStatus == .limited else { return }
        
        let fetchOptions = PHFetchOptions()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.fetchLimit = 50
        fetchOptions.sortDescriptors = [sortDescriptor]
        
        if let album = album {
            photosInCurrentAlbum = PHAsset.fetchAssets(in: album, options: fetchOptions)
        } else {
            photosInCurrentAlbum = PHAsset.fetchAssets(with: fetchOptions)
        }
    }

}
