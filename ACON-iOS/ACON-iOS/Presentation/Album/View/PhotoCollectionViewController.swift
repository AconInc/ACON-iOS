//
//  PhotoCollectionViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/9/25.
//

import UIKit

class PhotoCollectionViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    lazy var photoCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: photoCollectionViewFlowLayout)
    
    var photoCollectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 4
        $0.minimumInteritemSpacing = 4
        $0.itemSize = PhotoCollectionViewSizeType.cellSize.value
    }
    
    
    // MARK: - Properties
    
    private let albumViewModel: AlbumViewModel

    private var isDataLoaded = false
    
    var selectedIndexPath: ObservablePattern<IndexPath> = ObservablePattern(nil)
    
    private var selectedIndexPaths: [IndexPath] = []
    
    private var isLoading = false
    
    // MARK: - LifeCycle
    
    init(_ albumViewModel: AlbumViewModel) {
        self.albumViewModel = albumViewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
        registerCell()
        bindViewModel()
        bindSelectedIndexPath()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        albumViewModel.resetPhotoPagination()
        self.loadPhotos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setPopGesture()
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
        
        self.setCenterTitleLabelStyle(title: albumViewModel.albumInfo[albumViewModel.selectedAlbumIndex].title)
        self.setBackButton()
        self.setSelectButton()
        
        photoCollectionView.do {
            $0.backgroundColor = .clear
            $0.allowsMultipleSelection = (albumViewModel.flowType == .spotUpload)
        }
    }
    
    private func addTarget() {
        self.rightButton.addTarget(self,
                                   action: #selector(tappedRightButton),
                                   for: .touchUpInside)
    }

}


// MARK: - @objc functions

private extension PhotoCollectionViewController {

    @objc
    func tappedRightButton() {
        switch albumViewModel.flowType {
        case .profile:
            goToPhotoSelectionVC2()

        case .spotUpload:
            popToSpotUploadVC()
        }
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
    
    func bindSelectedIndexPath() {
        self.selectedIndexPath.bind { [weak self] selectedIndexPath in
            self?.rightButton.isEnabled = (selectedIndexPath == nil) ? false : true
        }
    }
    
}


// MARK: - Photo Load Methods

private extension PhotoCollectionViewController {
    
    func loadPhotos() {
        // NOTE: thumbnailSize 셀 크기로 하면 너무 화질 안 좋아짐 / 원본 사이즈는 현재 메모리 과부화 -> 적정선으로 우선 설정
        albumViewModel.loadPhotos(in: albumViewModel.albums[albumViewModel.selectedAlbumIndex],
                                  thumbnailSize: PhotoCollectionViewSizeType.thumbnailSize.value) {
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
        return photoCollectionViewFlowLayout.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch albumViewModel.flowType {
        case .profile:
            if let previousIndexPath = selectedIndexPath.value {
                if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? PhotoCollectionViewCell {
                    previousCell.isSelected = false
                }
                selectedIndexPath.value = nil
            }
            selectedIndexPath.value = indexPath

        case .spotUpload:
            if albumViewModel.maxPhotoCount > selectedIndexPaths.count {
                selectedIndexPaths.append(indexPath)
            } else {
                collectionView.deselectItem(at: indexPath, animated: true)
            }

            rightButton.isEnabled = !selectedIndexPaths.isEmpty
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard albumViewModel.flowType == .spotUpload else { return }

        selectedIndexPaths.removeAll { $0 == indexPath }

        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
            cell.isSelected = false
        }

        rightButton.isEnabled = !selectedIndexPaths.isEmpty
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
            albumViewModel.cancelImageLoad(for: asset, size: PhotoCollectionViewSizeType.thumbnailSize.value)
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
            cell.isSelected = (albumViewModel.flowType == .spotUpload) // NOTE: 셀 재사용되면서 상태 날아가는 이슈 방지
                ? selectedIndexPaths.contains(indexPath)
                : selectedIndexPath.value == indexPath

        } else {
            albumViewModel.setImageCache(for: data, size: PhotoCollectionViewSizeType.thumbnailSize.value) { cachedImage in
                DispatchQueue.main.async {
                    cell.dataBind(cachedImage ?? UIImage().withTintColor(.gray600),
                                  indexPath.item)
                }
            }
        }
        return cell
    }
    
}


// MARK: - Navigation

private extension PhotoCollectionViewController {
    
    func goToPhotoSelectionVC2() {
        albumViewModel.getHighQualityImage(index: selectedIndexPath.value?.item ?? 0) { [weak self] image in
            let vc = PhotoSelectionViewController(image)
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func popToSpotUploadVC() {
        let assets = selectedIndexPaths.map { albumViewModel.fetchedImages[$0.item].asset }

        let dispatchGroup = DispatchGroup()
        var selectedImages: [UIImage] = Array(repeating: UIImage(), count: assets.count)

        for (i, asset) in assets.enumerated() {
            dispatchGroup.enter()
            albumViewModel.setImageCache(for: asset,
                                         size: CGSize(width: asset.pixelWidth, height: asset.pixelHeight)) { image in
                selectedImages[i] = image ?? UIImage()
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self,
                  let navVCs = self.navigationController?.viewControllers else { return }

            if let spotUploadVC = navVCs.first(where: { $0 is SpotUploadViewController }) as? SpotUploadViewController {
                spotUploadVC.viewModel.photosToAppend.value = selectedImages
                self.navigationController?.popToViewController(spotUploadVC, animated: true)
            }
        }
    }

}
