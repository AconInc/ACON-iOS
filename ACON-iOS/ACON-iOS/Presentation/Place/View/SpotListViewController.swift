//
//  SpotListViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/11/25.
//

import UIKit

class SpotListViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let spotListView = SpotListView()
    private let spotListViewModel = SpotListViewModel()
    
    
    // MARK: - LifeCycle
    
    override func loadView() {
        view = spotListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
    }
    
}


// MARK: - @objc functions

extension SpotListViewController {
    
    @objc
    private func handleRefreshControl() {
        print("refresh control 실행됨")
        
        if !spotListViewModel.secondSpotList.isEmpty {
            spotListViewModel.isFirstPage.value?.toggle()
        } else {
            // TODO: 네트워크 요청
        }
        
        DispatchQueue.main.async {
            // 데이터 리로드 전 애니메이션
            UIView.animate(withDuration: 0.25, animations: {
                self.spotListView.collectionView.alpha = 0.5 // 투명도 낮춤
            }) { _ in
                // 데이터 리로드
                self.spotListView.collectionView.reloadData()
                
                // 데이터 리로드 후 애니메이션 (천천히 올라오는 애니메이션)
                UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut) {
                    // Set content offset with slow animation
                    self.spotListView.collectionView.setContentOffset(.zero, animated: true)
                    self.spotListView.collectionView.alpha = 1.0 // 투명도 복원
                } completion: { _ in
                    // 리프레시 종료
                    self.spotListView.collectionView.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
}


// MARK: - CollectionView Settings

extension SpotListViewController {
    
    private func setCollectionView() {
        setDelegate()
        registerCells()
        setRefreshControl()
    }
    
    private func setDelegate() {
        spotListView.collectionView.dataSource = self
        spotListView.collectionView.delegate = self
    }
    
    private func registerCells() {
        spotListView.collectionView.register(
            SpotListCollectionViewCell.self,
            forCellWithReuseIdentifier: SpotListCollectionViewCell.cellIdentifier
        )
    }
    
    private func setRefreshControl() {
        // TODO: Refresh control 디자인 변경
        
        let control = UIRefreshControl()
        
        control.addTarget(self,
                       action: #selector(handleRefreshControl),
                       for: .valueChanged
            )
        
        spotListView.collectionView.refreshControl = control
    }
    
}

extension SpotListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let isFirstPage = spotListViewModel.isFirstPage.value else { return 0 }
        
        return isFirstPage ? spotListViewModel.firstSpotList.count : spotListViewModel.secondSpotList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let isFirstPage = spotListViewModel.isFirstPage.value,
              let item = collectionView.dequeueReusableCell(
                withReuseIdentifier: SpotListCollectionViewCell.cellIdentifier,
                for: indexPath
              ) as? SpotListCollectionViewCell
        else { return UICollectionViewCell() }
        
        let spot = isFirstPage ? spotListViewModel.firstSpotList[indexPath.row] : spotListViewModel.secondSpotList[indexPath.row]
        
        // 1번페이지 1번째 셀만 취향 일치율 배경색 어둡게
        if isFirstPage,
           indexPath.item == 0 {
            item.bind(spot: spot, matchingRateBgColor: .dark)
        } else {
            item.bind(spot: spot, matchingRateBgColor: .light)
        }
        
        return item
    }
    
}

extension SpotListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 1번페이지 1번째 셀만 크게
        guard let isFirstPage = spotListViewModel.isFirstPage.value
        else { return .zero }
        
        let width: CGFloat = SpotListCollectionViewType.itemWidth
        let collectionViewHeight: CGFloat = collectionView.frame.height
        let shortHeight: CGFloat = SpotListCollectionViewType.shortItemHeight(collectionViewHeight)
        let longHeight: CGFloat = SpotListCollectionViewType.longItemHeight(collectionViewHeight)
        
        if isFirstPage,
           indexPath.item == 0 {
            return CGSize(width: width, height: longHeight)
        } else {
            return CGSize(width: width, height: shortHeight)
        }
    }
    
}
