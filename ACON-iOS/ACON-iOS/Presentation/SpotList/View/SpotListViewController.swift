//
//  SpotListViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/11/25.
//

import UIKit

class SpotListViewController: BaseNavViewController {
    
    // MARK: - Properties
    
    private let spotListView = SpotListView()
    private let spotListViewModel = SpotListViewModel()
    
    private var selectedSpotCondition: SpotConditionModel = SpotConditionModel(spotType: .restaurant, filterList: [], walkingTime: -1, priceRange: -1)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setCollectionView()
        addTarget()
        
        spotListViewModel.requestLocation()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        contentView.addSubview(spotListView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        spotListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setTitleLabelStyle(title: "동네 인증")
    }
    
    private func addTarget() {
        spotListView.floatingFilterButton.button.addTarget(
            self,
            action: #selector(tappedFilterButton),
            for: .touchUpInside
        )
        
        spotListView.floatingLocationButton.button.addTarget(
            self,
            action: #selector(tappedLocationButton),
            for: .touchUpInside
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handleRefreshControl()
    }
    
}


// MARK: - Bind ViewModel

extension SpotListViewController {
    
    func bindViewModel() {
        
        spotListViewModel.isPostSpotListSuccess.bind { [weak self] isSuccess in
            print("⚙️bindVM")
            guard let self = self,
                  let isSuccess = isSuccess else { return }
            print("jdkfds\(isSuccess)")
            if isSuccess {
                print("🥑\(spotListViewModel.isUpdated)")
                if spotListViewModel.isUpdated {
                    spotListView.collectionView.reloadData()
                    print("🥑reloadData")
                } else {
                    print("🥑데이터가 안 바뀌어서 리로드데이터 안 함")
                }
            } else {
                print("🥑Post 실패")
            }
            spotListViewModel.isUpdated = false
            spotListViewModel.isPostSpotListSuccess.value = nil
            endRefreshingAndTransparancy()
        }
        
    }
    
}


// MARK: - @objc functions

private extension SpotListViewController {
    
    @objc
    func handleRefreshControl() {
        spotListViewModel.requestLocation()
        
        DispatchQueue.main.async {
            // NOTE: 데이터 리로드 전 애니메이션
            UIView.animate(withDuration: 0.25, animations: {
                self.spotListView.collectionView.alpha = 0.5 // 투명도 낮춤
            }) { _ in
                
                self.spotListViewModel.postSpotList()
            }
        }
    }
    
    @objc
    func tappedFilterButton() {
        let vc = SpotListFilterViewController()
        vc.setLongSheetLayout()
        
        vc.completionHandler = { [weak self] selectedSpotCondition in
            guard let self = self else { return }
//            self.selectedSpotCondition = selectedSpotCondition
            spotListViewModel.spotType.value = selectedSpotCondition.spotType
            spotListViewModel.filterList = selectedSpotCondition.filterList
            
            spotListViewModel.postSpotList()
        }
        present(vc, animated: true)
    }
    
    
    @objc
    func tappedLocationButton() {
        // TODO: 내용 handleRefreshControl 부분으로 옮기기
        // TODO: 로그인중인지 여부
        let vc = LoginModalViewController()
        vc.setShortSheetLayout()
        
        present(vc, animated: true)
    }
}


// MARK: - CollectionView Reload animation

private extension SpotListViewController {
    
    func endRefreshingAndTransparancy() {
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.spotListView.collectionView.contentInset.top = 0
            self.spotListView.collectionView.setContentOffset(.zero, animated: true)
            self.spotListView.collectionView.alpha = 1.0 // NOTE: 투명도 복원
        } completion: { _ in
            self.spotListView.collectionView.refreshControl?.endRefreshing()
        }
    }
    
}


// MARK: - CollectionView Settings

private extension SpotListViewController {
    
    func setCollectionView() {
        setDelegate()
        registerCells()
        setRefreshControl()
    }
    
    func setDelegate() {
        spotListView.collectionView.dataSource = self
        spotListView.collectionView.delegate = self
    }
    
    func registerCells() {
        spotListView.collectionView.register(
            SpotListCollectionViewCell.self,
            forCellWithReuseIdentifier: SpotListCollectionViewCell.cellIdentifier
        )
        
        spotListView.collectionView.register(
            SpotListCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SpotListCollectionViewHeader.identifier)
    }
    
    func setRefreshControl() {
        let control = CustomRefreshControl()
        
        control.addTarget(self,
                          action: #selector(handleRefreshControl),
                          for: .valueChanged
        )
        
        spotListView.collectionView.refreshControl = control
    }
    
}


// MARK: - CollectionViewDataSource

extension SpotListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return spotListViewModel.spotList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(
                withReuseIdentifier: SpotListCollectionViewCell.cellIdentifier,
                for: indexPath
              ) as? SpotListCollectionViewCell
        else { return UICollectionViewCell() }
        
        let bgColor: MatchingRateBgColorType = indexPath.item == 0 ? .dark : .light
        
        item.bind(spot: spotListViewModel.spotList[indexPath.item],
                  matchingRateBgColor: bgColor)
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SpotListCollectionViewHeader.identifier,
                for: indexPath) as? SpotListCollectionViewHeader else {
            return UICollectionReusableView()
        }
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = spotListViewModel.spotList[indexPath.item]
        let vc = SpotDetailViewController(1) // TODO: 1 -> item.id로 변경
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - CollectionViewDelegateFlowLayout

extension SpotListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = SpotListItemSizeType.itemWidth.value
        let itemHeight: CGFloat = indexPath.row == 0 ? SpotListItemSizeType.longItemHeight.value : SpotListItemSizeType.shortItemHeight.value
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let itemWidth: CGFloat = SpotListItemSizeType.itemWidth.value
        let itemHeight: CGFloat = SpotListItemSizeType.headerHeight.value
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
