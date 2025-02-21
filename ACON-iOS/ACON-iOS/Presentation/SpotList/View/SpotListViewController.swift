//
//  SpotListViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/11/25.
//

import UIKit

class SpotListViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let spotListView = SpotListView()
    
    private let errorView = BaseErrorView(errorMessage: "", buttonTitle: "")
    
    
    // MARK: - Properties

    private let viewModel = SpotListViewModel()
    
    private var selectedSpotCondition: SpotConditionModel = SpotConditionModel(spotType: .restaurant, filterList: [], walkingTime: -1, priceRange: -1)
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setCollectionView()
        addTarget()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        self.tabBarController?.tabBar.isHidden = false
        viewModel.requestLocation()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        contentView.addSubviews(spotListView, errorView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        spotListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        errorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        setGlassMorphism()
        errorView.isHidden = true
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
        
        spotListView.floatingMapButton.button.addTarget(
            self,
            action: #selector(tappedMapButton),
            for: .touchUpInside
        )
    }
    
}


// MARK: - Bind ViewModel

extension SpotListViewController {
    
    func bindViewModel() {
        viewModel.onSuccessGetDong.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }
            if onSuccess {
                setTitleLabelStyle(title: viewModel.currentDong)
            } else if viewModel.errorType == .unsupportedRegion {
                self.setTitleLabelStyle(title: StringLiterals.SpotList.unsupportedRegionNavTitle)
            } else {
                self.setTitleLabelStyle(title: StringLiterals.SpotList.failedToGetAddressNavTitle)
            }
            viewModel.onSuccessGetDong.value = nil
        }
        
        viewModel.onSuccessPostSpotList.bind { [weak self] isSuccess in
            guard let self = self,
                  let isSuccess = isSuccess else { return }
            if isSuccess {
                if viewModel.hasSpotListChanged {
                    print("🥑데이터 바뀌어서 reloadData 함")
                    spotListView.collectionView.reloadData()
                    spotListView.hideSkeletonView(isHidden: true)
                } else {
                    print("🥑데이터가 안 바뀌어서 reloadData 안 함")
                    let dataExists = !viewModel.spotList.isEmpty
                    spotListView.hideSkeletonView(isHidden: dataExists)
                }
            } else {
                print("🥑추천장소리스트 Post 실패")
            }
            
            viewModel.hasSpotListChanged = false
            viewModel.onSuccessPostSpotList.value = nil
            endRefreshingAndTransparancy()
            
            let isFilterSet = !viewModel.filterList.isEmpty
            spotListView.updateFilterButtonColor(isFilterSet)
            
            viewModel.onFinishRefreshingSpotList.value = true
        }
        
        viewModel.showErrorView.bind { [weak self] showErrorView in
            guard let self = self,
                  let showErrorView = showErrorView else { return }
            
            if showErrorView {
                errorView.setStyle(errorMessage: viewModel.errorType?.errorMessage,
                                   buttonTitle: nil)
                errorView.isHidden = false
            } else {
                errorView.isHidden = true
            }
            
            viewModel.showErrorView.value = nil
        }
    }
    
}


// MARK: - @objc functions

private extension SpotListViewController {
    
    @objc
    func handleRefreshControl() {
        guard AuthManager.shared.hasToken else {
            presentLoginModal()
            spotListView.collectionView.do {
                $0.refreshControl?.endRefreshing()
                $0.setContentOffset(.zero, animated: true)
            }
            return
        }
        viewModel.requestLocation()
        
        DispatchQueue.main.async {
            // NOTE: 데이터 리로드 전 애니메이션
            UIView.animate(withDuration: 0.25, animations: {
                self.spotListView.collectionView.alpha = 0.5
            }) { _ in
                
                self.viewModel.requestLocation()
                self.spotListView.hideSkeletonView(isHidden: false)
            }
        }
    }
    
    @objc
    func tappedFilterButton() {
        guard AuthManager.shared.hasToken else {
            presentLoginModal()
            return
        }
        let vc = SpotListFilterViewController(viewModel: viewModel)
        vc.setSheetLayout(detent: .long)
        present(vc, animated: true)
    }
    
    
    @objc
    func tappedLocationButton() {
        // TODO: 내용 handleRefreshControl 부분으로 옮기기
        guard AuthManager.shared.hasToken else {
            presentLoginModal()
            return
        }
        // TODO: 할 거 하기
    }
    
    @objc
    func tappedMapButton() {
        // TODO: 내용 handleRefreshControl 부분으로 옮기기
        guard AuthManager.shared.hasToken else {
            presentLoginModal()
            return
        }
        // TODO: 맵뷰 띄우기
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
        
        spotListView.collectionView.register(
            SpotListCollectionViewFooter.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: SpotListCollectionViewFooter.identifier)
    }
    
    func setRefreshControl() {
        spotListView.collectionView.refreshControl = CustomRefreshControl()
        spotListView.collectionView.refreshControl?.addTarget(
            self,
            action: #selector(handleRefreshControl),
            for: .valueChanged
        )
    }
    
}


// MARK: - CollectionViewDataSource

extension SpotListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.spotList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(
                withReuseIdentifier: SpotListCollectionViewCell.cellIdentifier,
                for: indexPath
              ) as? SpotListCollectionViewCell
        else { return UICollectionViewCell() }
        
        let bgColor: MatchingRateBgColorType = indexPath.item == 0 ? .dark : .light
        
        item.bind(spot: viewModel.spotList[indexPath.item],
                  matchingRateBgColor: bgColor)
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       viewForSupplementaryElementOfKind kind: String,
                       at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SpotListCollectionViewHeader.identifier,
                for: indexPath) as? SpotListCollectionViewHeader else {
                fatalError("Cannot dequeue header view")
            }
            return header
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SpotListCollectionViewFooter.identifier,
                for: indexPath) as? SpotListCollectionViewFooter else {
                fatalError("Cannot dequeue footer view")
            }
            return footer
        default:
            fatalError("Unexpected supplementary view kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.spotList[indexPath.item]
        let vc = SpotDetailViewController(item.id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - 글라스모피즘 스크롤 시 선택
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
           
        if offset > 0 {
            [topInsetView, navigationBarView].forEach {
                $0.backgroundColor = .clear
            }
            self.glassMorphismView.isHidden = false
        } else {
            [topInsetView, navigationBarView].forEach {
                $0.backgroundColor = .gray9
            }
            self.glassMorphismView.isHidden = true
        }
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        let itemWidth: CGFloat = SpotListItemSizeType.itemWidth.value
        let itemHeight: CGFloat = SpotListItemSizeType.footerHeight.value
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
