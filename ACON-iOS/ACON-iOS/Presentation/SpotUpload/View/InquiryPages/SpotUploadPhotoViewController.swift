//
//  SpotUploadPhotoViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/31/25.
//

import UIKit

// MARK: - Delegate Protocol

protocol SpotUploadPhotoViewControllerDelegate {

    func pushAlbumTableVC()

}


// MARK: - ViewController

class SpotUploadPhotoViewController: BaseUploadInquiryViewController {

    // MARK: - UI Properties

    private let collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: SpotUploadSizeType.Photo.itemWidth.value,
                             height: SpotUploadSizeType.Photo.itemHeight.value)
        $0.minimumInteritemSpacing = SpotUploadSizeType.Photo.interItemSpacing.value
        $0.scrollDirection = .horizontal
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)


    // MARK: - Properties

    var delegate: SpotUploadPhotoViewControllerDelegate?

    override var contentViews: [UIView] {
        [collectionView]
    }

    override var canGoPrevious: Bool { true }
    override var canGoNext: Bool { true }

    private let albumViewModel = AlbumViewModel()


    // MARK: - init

    init(_ viewModel: SpotUploadViewModel) {
        super.init(viewModel: viewModel,
                   requirement: .required,
                   title: StringLiterals.SpotUpload.isThisValueForMoney)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegate()
        registerCells()
    }

    override func setLayout() {
        super.setLayout()

        let sizeType = SpotUploadSizeType.Photo.self
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(sizeType.itemHeight.value)
        }
    }

}


// MARK: - CollectionView Settings

private extension SpotUploadPhotoViewController {

    func setDelegate() {
        collectionView.dataSource = self
    }

    func registerCells() {
        collectionView.register(SpotUploadPhotoCollectionViewCell.self, forCellWithReuseIdentifier: SpotUploadPhotoCollectionViewCell.identifier)
    }
}

// MARK: - @objc functions

private extension SpotUploadPhotoViewController {


}


// MARK: - Helper

private extension SpotUploadPhotoViewController {

}


// MARK: - CollectionView Datasource

extension SpotUploadPhotoViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let photosCount = viewModel.photos.count
        return photosCount == 10 ? photosCount : photosCount + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: SpotUploadPhotoCollectionViewCell.identifier, for: indexPath) as? SpotUploadPhotoCollectionViewCell else { return UICollectionViewCell() }

        item.delegate = self

        if indexPath.item == viewModel.photos.count {
            // NOTE: + 셀
            item.setAddView()
        } else {
            // NOTE: 사진 셀
            item.setPhoto(viewModel.photos[indexPath.item], for: indexPath)
        }

        return item
    }

}


extension SpotUploadPhotoViewController: SpotUploadPhotoCellDelegate {

    func deletePhoto(for indexPath: IndexPath) {
        let deleteAction: () -> Void = { [weak self] in
            guard let self = self else { return }
            viewModel.photos.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
        }
        presentACAlert(.deletePhoto, rightAction: deleteAction)
    }

    func addPhoto() {
        delegate?.pushAlbumTableVC()
    }

}
