//
//  SavedSpotsViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/11/25.
//

import UIKit

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.tabBar.isHidden = true
        if AuthManager.shared.hasToken {
            viewModel.getSavedSpots()
        }
    }

    
    // MARK: - UI Setting Methods

    override func setStyle() {
        super.setStyle()
        
        setBackButton()
        setCenterTitleLabelStyle(title: "저장한 장소")
        savedSpotCollectionView.do {
            $0.backgroundColor = .clear
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


// MARK: - CollectionView Delegate

extension SavedSpotsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return savedSpotCollectionViewFlowLayout.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedSpotID = viewModel.userInfo.savedSpotList?[indexPath.item].id else { return }
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
        cell.bindData(data, indexPath.item)

        return cell
    }
    
}
