//
//  PhotoCollectionViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/9/25.
//

import UIKit

class PhotoCollectionViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    var photoCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: photoCollectionViewFlowLayout
    )
    
    static let cellWidth = CGFloat((ScreenUtils.width - 12) / 4)
    
    static let cellSize = CGSize(width: cellWidth, height: cellWidth)
    
    static let thumbnailSize = CGSize(width: 300, height: 300)
    
    static var photoCollectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 0
        $0.itemSize = cellSize
    }
    
    // MARK: - Properties
    
    private let albumViewModel = AlbumViewModel()

    private var isDataLoaded = false
    
    var selectedIndexPath: IndexPath?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
        registerCell()
        bindViewModel()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.tabBar.isHidden = true
        loadPhotos()
    }

    override func setHierarchy() {
        super.setHierarchy()
        
        self.contentView.addSubview(photoCollectionView)
    }
    
    override func setLayout() {
        super.setLayout()

        photoCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setCenterTitleLabelStyle(title: "앨범")
        self.setBackButton()
        self.setSelectButton()
        
        photoCollectionView.do {
            $0.backgroundColor = .clear
        }
    }
    
    private func addTarget() {
        
    }

}


// MARK: - bindViewModel

private extension PhotoCollectionViewController {
    
    func bindViewModel() {
        self.albumViewModel.onSuccessLoadImages.bind { [weak self] onSuccess in
            guard let onSuccess else { return }
            if onSuccess {
                self?.photoCollectionView.reloadData()
                self?.albumViewModel.onSuccessLoadImages.value = false
            }
        }
    }
    
}


// MARK: - Photo Load Methods

private extension PhotoCollectionViewController {
    
    func loadPhotos() {
        // NOTE: thumbnailSize 셀 크기로 하면 너무 화질 안 좋아짐 / 원본 사이즈는 현재 메모리 과부화 -> 적정선으로 우선 설정
        albumViewModel.loadPhotos(in: albumViewModel.smartAlbums.first,
                                  thumbnailSize: PhotoCollectionViewController.thumbnailSize) {
            self.isDataLoaded = true
            return
        }
    }
    
}

// MARK: - CollectionView Setting Methods

extension PhotoCollectionViewController {
    
    func registerCell() {
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.cellIdentifier)
    }
    
    func setDelegate() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
    
}

// MARK: - CollectionView Delegate

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return PhotoCollectionViewController.photoCollectionViewFlowLayout.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndexPath = selectedIndexPath {
            // NOTE: deselectItem 메소드 사용 시 가끔 오류
            if let cell = collectionView.cellForItem(at: previousIndexPath) as? PhotoCollectionViewCell {
                cell.isSelected = false
            }
        }
        
        selectedIndexPath = indexPath
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
            cell.isSelected = true
        }
    }
    
    /// 스크롤 시 다음 사진 batch를 불러줌.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if offsetY > contentHeight - frameHeight - 30 {
            loadPhotos()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /// 화면에서 벗어난 셀의 이미지 로드를 취소하고 캐시에서 제거
        if indexPath.item < albumViewModel.fetchedImages.count {
            let asset = albumViewModel.fetchedImages[indexPath.item].asset
            albumViewModel.cancelImageLoad(for: asset, size: PhotoCollectionViewController.thumbnailSize)
        }
    }
    
}


// MARK: - CollectionView DataSource

extension PhotoCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumViewModel.fetchedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.cellIdentifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        guard isDataLoaded else { return cell }
        
        let data = albumViewModel.fetchedImages[indexPath.item].asset
        
        if let cachedImage = albumViewModel.getCachedImage(for: data) {
            cell.dataBind(cachedImage, indexPath.item)
        } else {
            albumViewModel.setImageCache(for: data, size: PhotoCollectionViewController.thumbnailSize) { cachedImage in
                DispatchQueue.main.async {
                    cell.dataBind(cachedImage ?? UIImage().withTintColor(.gray6),
                                  indexPath.item)
                }
            }
        }
        return cell
    }
    
}
