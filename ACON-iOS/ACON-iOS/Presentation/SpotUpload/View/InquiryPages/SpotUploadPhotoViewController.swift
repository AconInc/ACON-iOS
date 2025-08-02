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
        bind()
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

    override func setStyle() {
        super.setStyle()

        collectionView.do {
            let insetX = SpotUploadSizeType.Photo.insetX.value
            $0.backgroundColor = .clear
            $0.decelerationRate = .fast
            $0.showsHorizontalScrollIndicator = false
            $0.contentInset = .init(top: 0, left: insetX, bottom: 0, right: insetX)
        }
    }

    private func bind() {
        viewModel.photosToAppend.bind { [weak self] photos in
            guard let self, let photos else { return }

            let currentCount = viewModel.photos.count
            let willAddCount = min(10 - currentCount, photos.count)
            let newIndexPath: [IndexPath] = (0..<willAddCount).map { IndexPath(item: currentCount + $0, section: 0) }

            viewModel.photosToAppend.value = nil
            viewModel.photos.append(contentsOf: photos[0..<willAddCount])
            
            if viewModel.photos.count == 10 {
                collectionView.reloadData() // NOTE: + 셀이 사라지므로 전체 reload (or index 오류 남)
            } else {
                collectionView.insertItems(at: newIndexPath)
            }
            collectionView.setContentOffset(collectionViewOffset(for: viewModel.photos.count - 1), animated: true)
        }
    }

}


// MARK: - CollectionView Settings

private extension SpotUploadPhotoViewController {

    func setDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func registerCells() {
        collectionView.register(SpotUploadPhotoCollectionViewCell.self, forCellWithReuseIdentifier: SpotUploadPhotoCollectionViewCell.identifier)
    }
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
            item.setAddView() // NOTE: + 셀
        } else {
            item.setPhoto(viewModel.photos[indexPath.item]) // NOTE: 사진 셀
        }

        return item
    }

}


// MARK: - CollectionView Delegate

extension SpotUploadPhotoViewController: UICollectionViewDelegateFlowLayout {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidth = SpotUploadSizeType.Photo.itemWidth.value
        let interItemSpacing = SpotUploadSizeType.Photo.interItemSpacing.value
        let oneUnitWidth = cellWidth + interItemSpacing

        let targetX = targetContentOffset.pointee.x
        let index = round(targetX / oneUnitWidth)

        // NOTE: 화면 중앙과 가장 가까운 셀을 찾아 화면 중앙으로 이동
        targetContentOffset.pointee = collectionViewOffset(for: Int(index))
    }

}


// MARK: - Cell Delegate

extension SpotUploadPhotoViewController: SpotUploadPhotoCellDelegate {

    func deletePhoto(for cell: UICollectionViewCell) {
        let deleteAction: () -> Void = { [weak self] in
            guard let self,
                  let indexPath = self.collectionView.indexPath(for: cell) else { return }

            viewModel.photos.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
        }
        presentACAlert(.deletePhoto, rightAction: deleteAction)
    }

    func addPhoto() {
        delegate?.pushAlbumTableVC()
    }

}


// MARK: - Helper

private extension SpotUploadPhotoViewController {

    func collectionViewOffset(for index: Int) -> CGPoint {
        let cellWidth = SpotUploadSizeType.Photo.itemWidth.value
        let interItemSpacing = SpotUploadSizeType.Photo.interItemSpacing.value
        let insetX = SpotUploadSizeType.Photo.insetX.value
        let oneUnitWidth = cellWidth + interItemSpacing

        let newTargetX = CGFloat(index) * oneUnitWidth - insetX
        return CGPoint(x: newTargetX, y: 0)
    }

}
