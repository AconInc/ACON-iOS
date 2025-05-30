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
    
    private let viewModel = SpotListViewModel()
    
    private let spotToggleButton = SpotToggleButtonView()
    
    private let filterButton = UIButton()
    
    private var isViewInitialRender = true
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        bindObservable()
        setCollectionView()
        addTarget()
        viewModel.requestLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        contentView.addSubview(spotListView)
        navigationBarView.addSubviews(spotToggleButton, filterButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        spotListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        spotToggleButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        filterButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(36)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        setGlassMorphism()
        spotListView.errorView.isHidden = true
        
        filterButton.do {
            var config = UIButton.Configuration.filled()
            config.image = .icFilter
            config.background.strokeWidth = 1
            config.cornerStyle = .capsule
            $0.configuration = config
            
            $0.configurationUpdateHandler = { button in
                switch button.state {
                case .selected:
                    button.configuration?.baseBackgroundColor = .gray600 // TODO: glassmorphism
                    button.configuration?.background.strokeColor = .gray300
                default:
                    button.configuration?.baseBackgroundColor = .clear
                    button.configuration?.background.strokeColor = .clear
                }
            }
        }
    }
            
    private func addTarget() {
        filterButton.addTarget(
            self,
            action: #selector(tappedFilterButton),
            for: .touchUpInside
        )
        
        spotListView.errorView.confirmButton.addTarget(
            self,
            action: #selector(tappedReloadButton),
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
            
            // NOTE: 법정동 조회 성공 -> 네비게이션타이틀
            if onSuccess {
                viewModel.postSpotList()
            }
            
            // NOTE: 법정동 조회 실패 (서비스불가지역) -> 에러 뷰, 네비게이션타이틀
            else if viewModel.errorType == .unsupportedRegion {
                spotListView.errorView.setStyle(errorMessage: viewModel.errorType?.errorMessage,
                                   buttonTitle: "새로고침 하기")
            }
            
            // NOTE: 법정동 조회 실패 (기타 에러) -> 에러뷰, 네비게이션타이틀
            else {
                spotListView.errorView.setStyle(errorMessage: viewModel.errorType?.errorMessage,
                                   buttonTitle: "새로고침 하기")
            }
            
            // NOTE: 에러뷰 숨김 여부 처리
            spotListView.errorView.isHidden = onSuccess
            
            viewModel.onSuccessGetDong.value = nil
        }
        
        viewModel.onSuccessPostSpotList.bind { [weak self] isSuccess in
            guard let self = self,
                  let isSuccess = isSuccess else { return }
            let spotList = viewModel.spotType == .restaurant ? viewModel.restaurantList : viewModel.cafeList
            if isSuccess {
                DispatchQueue.main.async {
                    self.spotListView.errorView.isHidden = true
                    self.spotListView.updateCollectionViewLayout(type: spotList.transportMode)
                    self.spotListView.collectionView.reloadData()
                }
                
                // NOTE: 스켈레톤 최소 0.5초 유지
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    guard let self = self else { return }
                    spotListView.hideSkeletonView(isHidden: true)
                    let isRestaurantEmpty: Bool = viewModel.spotType == .restaurant && viewModel.restaurantList.spotList.isEmpty
                    let isCafeEmpty: Bool = viewModel.spotType == .cafe && viewModel.cafeList.spotList.isEmpty
                    if isRestaurantEmpty || isCafeEmpty {
                        spotListView.errorView.setStyle(
                            errorMessage: viewModel.errorType?.errorMessage,
                            buttonTitle: nil
                        )
                        spotListView.errorView.isHidden = false
                    }
                }
            } else {
                // TODO: 네트워크 에러뷰로 교체, 버튼에 postSpotList() 액션 설정
                spotListView.errorView.setStyle(
                    errorMessage: StringLiterals.Error.networkErrorOccurred,
                    buttonTitle: StringLiterals.Error.tryAgain
                )
                spotListView.hideSkeletonView(isHidden: true)
                
                // TODO: Post 하는동안 로딩스켈레톤
                
            }
            
            viewModel.onSuccessPostSpotList.value = nil
            endRefreshingAndTransparancy()
            
            filterButton.isSelected = !viewModel.filterList.isEmpty
            
            viewModel.onFinishRefreshingSpotList.value = true
            
            // NOTE: 에러뷰 숨김 여부 처리
            spotListView.errorView.isHidden = isSuccess
        }
    }
    
    func bindObservable() {
        spotToggleButton.selectedType.bind { [weak self] spotType in
            guard let self = self,
                  let spotType = spotType else { return }
            viewModel.spotType = spotType
            
            spotListView.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            spotListView.collectionView.reloadData()
            viewModel.filterList = []
            viewModel.postSpotList()
        }
    }
    
}


// MARK: - @objc functions

private extension SpotListViewController {
    
    @objc
    func handleRefreshControl() {
        guard AuthManager.shared.hasToken else {
            presentLoginModal(AmplitudeLiterals.EventName.mainMenu)
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
            }) { [weak self] _ in
                
                self?.viewModel.requestLocation()
                self?.spotListView.hideSkeletonView(isHidden: false)
            }
        }
    }
    
    @objc
    func tappedFilterButton() {
        guard AuthManager.shared.hasToken else {
            presentLoginModal(AmplitudeLiterals.EventName.filter)
            return
        }
        let vc = SpotListFilterViewController(viewModel: viewModel)
        vc.setSheetLayout(detent: .long)
        vc.isModalInPresentation = true
        
        present(vc, animated: true)
    }

    @objc
    func tappedReloadButton() {
        spotListView.hideSkeletonView(isHidden: false)
        guard AuthManager.shared.hasToken else {
            presentLoginModal(AmplitudeLiterals.EventName.mainMenu)
            return
        }
        spotListView.hideSkeletonView(isHidden: false)
        viewModel.requestLocation()
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
            NoMatchingSpotListCollectionViewCell.self,
            forCellWithReuseIdentifier: NoMatchingSpotListCollectionViewCell.cellIdentifier
        )
        
        spotListView.collectionView.register(
            SpotListCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SpotListCollectionViewHeader.identifier
        )

        spotListView.collectionView.register(
            NoMatchingSpotHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: NoMatchingSpotHeader.identifier
        )
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
        return viewModel.spotType == .restaurant ? viewModel.restaurantList.spotList.count : viewModel.cafeList.spotList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let spotList = viewModel.spotType == .restaurant ? viewModel.restaurantList : viewModel.cafeList

        switch spotList.transportMode {
        case .walking:
            return dequeueAndConfigureCell(
                collectionView: collectionView,
                cellType: SpotListCollectionViewCell.self,
                at: indexPath,
                with: spotList
            )
        case .biking:
            return dequeueAndConfigureCell(
                collectionView: collectionView,
                cellType: NoMatchingSpotListCollectionViewCell.self,
                at: indexPath,
                with: spotList
            )
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let spotList = viewModel.spotType == .restaurant ? viewModel.restaurantList : viewModel.cafeList

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch spotList.transportMode {
            case .walking:
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SpotListCollectionViewHeader.identifier,
                    for: indexPath) as? SpotListCollectionViewHeader else {
                    fatalError("Cannot dequeue header view")
                }
                return header
            default:
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: NoMatchingSpotHeader.identifier,
                    for: indexPath) as? NoMatchingSpotHeader else {
                    fatalError("Cannot dequeue header view")
                }
                header.setHeader(spotList.spotList.isEmpty ? .noSuggestion : .withSuggestion)
                return header
            }
        default:
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.spotType == .restaurant ? viewModel.restaurantList.spotList[indexPath.item] : viewModel.cafeList.spotList[indexPath.item]
        let vc = SpotDetailViewController(item.id, item.tagList)

        ACLocationManager.shared.removeDelegate(viewModel)
        vc.backCompletion = { [weak self] in
            guard let self = self else { return }
            ACLocationManager.shared.addDelegate(self.viewModel)
        }

        if AuthManager.shared.hasToken {
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            presentLoginModal(AmplitudeLiterals.EventName.tappedSpotCell)
        }
    }

}


// MARK: - CollectionViewDelegateFlowLayout

extension SpotListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let spotList = viewModel.spotType == .restaurant ? viewModel.restaurantList : viewModel.cafeList
        if spotList.transportMode == .walking {
            return CGSize(width: SpotListItemSizeType.itemMaxWidth.value,
                          height: SpotListItemSizeType.headerHeight.value)
        } else if spotList.transportMode == .biking {
            return CGSize(width: NoMatchingSpotListItemSizeType.itemWidth.value,
                          height: NoMatchingSpotListItemSizeType.withSuggestionHeaderHeight.value)
        } else {
            return CGSize(width: NoMatchingSpotListItemSizeType.itemWidth.value,
                          height: NoMatchingSpotListItemSizeType.noSuggestionHeaderHeight.value)
        }
    }

}


// MARK: - UIScrollViewDelegate

extension SpotListViewController: UIScrollViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if viewModel.restaurantList.transportMode == .walking {
            let cellHeight = SpotListItemSizeType.itemMaxHeight.value + SpotListItemSizeType.minimumLineSpacing.value
            let targetY = targetContentOffset.pointee.y
            
            // NOTE: 화면 중앙과 가장 가까운 셀을 찾아 화면 중앙으로 이동
            let newTargetY = round(targetY / cellHeight) * cellHeight + SpotListItemSizeType.minimumLineSpacing.value / 2
            targetContentOffset.pointee = CGPoint(x: 0, y: newTargetY)
        }
    }

}


// MARK: - CollectionView Helper

private extension SpotListViewController {

    private func dequeueAndConfigureCell<T: UICollectionViewCell & SpotListCellConfigurable>(
        collectionView: UICollectionView,
        cellType: T.Type,
        at indexPath: IndexPath,
        with spotList: SpotListModel
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellType.cellIdentifier,
            for: indexPath
        ) as? T else {
            return UICollectionViewCell()
        }

        let lockCell = !AuthManager.shared.hasToken && indexPath.item > 4

        cell.bind(spot: spotList.spotList[indexPath.item])
        cell.overlayLoginLock(lockCell)

        return cell
    }

    // NOTE: CollectionView Reload animation
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
