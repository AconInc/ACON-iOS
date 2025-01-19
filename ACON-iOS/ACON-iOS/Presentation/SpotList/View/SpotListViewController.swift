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
        spotListViewModel.isFirstPage.bind { [weak self] isFirstPage in
            guard let self = self,
                  let isFirstPage = isFirstPage else { return }
            spotListView.hideFooterLabel(isHidden: isFirstPage)
        }
    }
}


// MARK: - @objc functions

private extension SpotListViewController {
    
    @objc
    func handleRefreshControl() {
        print("refresh control 실행됨")
        
        if !spotListViewModel.secondSpotList.isEmpty {
            spotListViewModel.isFirstPage.value?.toggle()
        } else {
            // TODO: 네트워크 요청
        }
        
        DispatchQueue.main.async {
            // NOTE: 데이터 리로드 전 애니메이션
            UIView.animate(withDuration: 0.25, animations: {
                self.spotListView.collectionView.alpha = 0.5 // 투명도 낮춤
            }) { _ in
                // NOTE: 데이터 리로드
                self.spotListView.collectionView.reloadData()
                
                // NOTE: 데이터 리로드 후 애니메이션 (천천히 올라오는 애니메이션)
                UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut) {
                    self.spotListView.collectionView.setContentOffset(.zero, animated: true)
                    self.spotListView.collectionView.alpha = 1.0 // 투명도 복원
                } completion: { _ in
                    // NOTE: 리프레시 종료
                    self.spotListView.collectionView.refreshControl?.endRefreshing()
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
        // TODO: Refresh control 디자인 변경
        
        let control = UIRefreshControl()
        
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
        guard let isFirstPage = spotListViewModel.isFirstPage.value else { return 0 }
        
        return isFirstPage ? spotListViewModel.firstSpotList.count : spotListViewModel.secondSpotList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let isFirstPage = spotListViewModel.isFirstPage.value,
              let item = collectionView.dequeueReusableCell(
                withReuseIdentifier: SpotListCollectionViewCell.cellIdentifier,
                for: indexPath
              ) as? SpotListCollectionViewCell
        else { return UICollectionViewCell() }
        
        let spot = isFirstPage ? spotListViewModel.firstSpotList[indexPath.row] : spotListViewModel.secondSpotList[indexPath.row]
        
        // NOTE: 1번페이지 1번째 셀만 취향 일치율 배경색 어둡게
        let bgColor: MatchingRateBgColorType = isFirstPage && indexPath.item == 0 ? .dark : .light
        
        item.bind(spot: spot, matchingRateBgColor: bgColor)
        
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
        // NOTE: 1번페이지 1번째 셀만 크게
        guard let isFirstPage = spotListViewModel.isFirstPage.value
        else { return .zero }
        
        let itemWidth: CGFloat = SpotListItemSizeType.itemWidth.value
        let collectionViewHeight: CGFloat = collectionView.frame.height
        let shortHeight: CGFloat = shortItemHeight(collectionViewHeight)
        let longHeight: CGFloat = longItemHeight(collectionViewHeight)
        let itemHeight = isFirstPage && indexPath.item == 0 ? longHeight : shortHeight
        
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
