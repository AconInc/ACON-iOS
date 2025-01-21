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
    }
    
}


// MARK: - Bind ViewModel

extension SpotListViewController {
    
    func bindViewModel() {
        spotListViewModel.isNetworkingSuccess.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            if spotListViewModel.isUpdated {
                spotListView.collectionView.reloadData()
            }
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
                
                // TODO: 네트워크 요청
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1) { // TODO: 네트워킹동안 뷰 작동 테스트를 위한 것. 추후 삭제
                    self.spotListViewModel.spotList = SpotModel.dummy
                    self.spotListViewModel.fetchSpotList()
                }
            }
        }
    }
    
    @objc
    func tappedFilterButton() {
        let vc = SpotListFilterViewController()
        vc.setLongSheetLayout()
        
        present(vc, animated: true)
    }
    
}


// MARK: - CollectionView Reload animation

private extension SpotListViewController {
    
    func endRefreshingAndTransparancy() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut) {
            self.spotListView.collectionView.setContentOffset(.zero, animated: true)
            self.spotListView.collectionView.alpha = 1.0 // 투명도 복원
        } completion: { _ in
            // NOTE: 리프레시 종료
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
    
}


// MARK: - CollectionViewDelegateFlowLayout

extension SpotListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = SpotListItemSizeType.itemWidth.value
        let collectionViewHeight: CGFloat = collectionView.frame.height
        let shortHeight: CGFloat = shortItemHeight(collectionViewHeight)
        let longHeight: CGFloat = longItemHeight(collectionViewHeight)
        
        let itemHeight = indexPath.item == 0 ? longHeight : shortHeight
        
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


// MARK: - CollectionView ItemSize Method

extension SpotListViewController {
    
    func longItemHeight(_ collectionViewHeight: CGFloat) -> CGFloat {
        let lineSpacing = SpotListItemSizeType.minimumLineSpacing.value
        let headerHeight = SpotListItemSizeType.headerHeight.value
        let shortHeight = shortItemHeight(collectionViewHeight)
        return collectionViewHeight - shortHeight - lineSpacing - headerHeight
    }
    
    func shortItemHeight(_ collectionViewHeight: CGFloat) -> CGFloat {
        let lineSpacing = SpotListItemSizeType.minimumLineSpacing.value
        let headerHeight = SpotListItemSizeType.headerHeight.value
        return (collectionViewHeight - lineSpacing * 3 - headerHeight) / 4
    }
    
}
