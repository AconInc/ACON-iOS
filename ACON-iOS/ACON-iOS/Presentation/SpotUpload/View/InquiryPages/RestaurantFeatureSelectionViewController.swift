//
//  RestaurantFeatureSelectionViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/23/25.
//

import UIKit

class RestaurantFeatureSelectionViewController: BaseUploadInquiryViewController {

    // MARK: - UI Properties

    private let collectionViewLayout = UICollectionViewFlowLayout().then {
        let horizontalInset = 20 * ScreenUtils.widthRatio
        $0.itemSize = CGSize(width: (ScreenUtils.width - horizontalInset * 2 - 8) / 2, height: 40)
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 8
        $0.sectionInset = .init(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)


    // MARK: - Properties

    override var contentViews: [UIView] {
        [collectionView]
    }

    override var canGoPrevious: Bool { true }
    override var canGoNext: Bool { !viewModel.restaurantFeature.isEmpty }

    private let restaurantFeatures = SpotUploadType.RestaurantOptionType.allCases


    // MARK: - init

    init(_ viewModel: SpotUploadViewModel) {
        super.init(viewModel: viewModel,
                   requirement: .required,
                   title: StringLiterals.SpotUpload.whatKindOfRestaurant)
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


    // MARK: - UI Setting

    override func setLayout() {
        super.setLayout()

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setStyle() {
        super.setStyle()

        collectionView.backgroundColor = .clear
    }

    private func setDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func registerCells() {
        collectionView.register(SpotUploadOptionCell.self, forCellWithReuseIdentifier: SpotUploadOptionCell.identifier)
    }

}


// MARK: - CollectionView DataSource

extension RestaurantFeatureSelectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantFeatures.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: SpotUploadOptionCell.identifier, for: indexPath) as? SpotUploadOptionCell else { return UICollectionViewCell() }

        let feature = restaurantFeatures[indexPath.item]
        item.bindData(feature.text)
        item.isButtonSelected = viewModel.restaurantFeature.contains(feature)

        return item
    }

}

extension RestaurantFeatureSelectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SpotUploadOptionCell else { return }
        cell.isButtonSelected.toggle()

        if cell.isButtonSelected {
            viewModel.restaurantFeature.insert(restaurantFeatures[indexPath.item])
        } else {
            viewModel.restaurantFeature.remove(restaurantFeatures[indexPath.item])
        }

        updatePagingButtonStates()
    }

}
