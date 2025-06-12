//
//  SavedSpotsViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/11/25.
//

import UIKit

import SkeletonView

final class SavedSpotsViewController: BaseNavViewController {

    // MARK: - UI Properties

    lazy var savedSpotCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: savedSpotCollectionViewFlowLayout)

    let savedSpotCollectionViewFlowLayout: UICollectionViewFlowLayout = LeftAlignedCollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumInteritemSpacing = 8
        $0.minimumLineSpacing = 8
        $0.sectionInset = UIEdgeInsets(top: ScreenUtils.horizontalInset,
                                       left: ScreenUtils.horizontalInset,
                                       bottom: 0,
                                       right: ScreenUtils.horizontalInset)
        $0.itemSize = CGSize(width: 160*ScreenUtils.widthRatio,
                             height: 231*ScreenUtils.heightRatio)
    }
    
    
    // MARK: - Properties
    
    private let viewModel = ProfileViewModel()


    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        registerCell()
        setDelegate()
        setSkeleton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.tabBar.isHidden = true
        if AuthManager.shared.hasToken {
            viewModel.getSavedSpots()
            savedSpotCollectionView.startACSkeletonAnimation()
        }

    }

    
    // MARK: - UI Setting Methods

    override func setStyle() {
        super.setStyle()
        
        setBackButton()
        setCenterTitleLabelStyle(title: "저장한 장소")
        savedSpotCollectionView.do {
            $0.backgroundColor = .clear
            $0.isSkeletonable = true
        }
    }

    override func setHierarchy() {
        super.setHierarchy()

        self.contentView.addSubview(savedSpotCollectionView)
    }

    override func setLayout() {
        super.setLayout()

        savedSpotCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}


// MARK: - Bindings

private extension SavedSpotsViewController {

    func bindViewModel() {
        viewModel.onGetSavedSpotsSuccess.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }
            if onSuccess {
                savedSpotCollectionView.reloadData()
            }
            viewModel.onGetSavedSpotsSuccess.value = nil
            
            // NOTE: 최소 1초 스켈레톤 유지
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.savedSpotCollectionView.hideSkeleton()
            }
        }
    }

}


// MARK: - CollectionView Setting Methods

private extension SavedSpotsViewController {
    
    func registerCell() {
        savedSpotCollectionView.register(SavedSpotCollectionViewCell.self, forCellWithReuseIdentifier: SavedSpotCollectionViewCell.cellIdentifier)
    }
    
    func setDelegate() {
        savedSpotCollectionView.delegate = self
        savedSpotCollectionView.dataSource = self
    }
    
}


// MARK: - Skeleton Controls

private extension SavedSpotsViewController {

    func setSkeleton() {
        savedSpotCollectionView.prepareSkeleton { _ in
        }
    }

}


// MARK: - CollectionView Delegate

extension SavedSpotsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return savedSpotCollectionViewFlowLayout.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSpotID = viewModel.savedSpotList[indexPath.item].id
        let vc = SpotDetailViewController(selectedSpotID, [])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


// MARK: - CollectionView DataSource

extension SavedSpotsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.savedSpotList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedSpotCollectionViewCell.cellIdentifier, for: indexPath) as? SavedSpotCollectionViewCell else {
            return UICollectionViewCell() }
        
        let data = viewModel.savedSpotList[indexPath.item]
        cell.bindData(data)
        cell.isSkeletonable = true

        return cell
    }
    
}


// MARK: - Skeleton CollectionView DataSource

extension SavedSpotsViewController: SkeletonCollectionViewDataSource {

    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        return skeletonView.dequeueReusableCell(
            withReuseIdentifier: SavedSpotCollectionViewCell.cellIdentifier,
            for: indexPath
        )
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return SavedSpotCollectionViewCell.identifier
    }
    
}
