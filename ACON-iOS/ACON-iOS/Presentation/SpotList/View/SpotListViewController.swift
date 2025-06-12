//
//  SpotListViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/11/25.
//

import UIKit

import SkeletonView

class SpotListViewController: BaseNavViewController {

    // MARK: - Properties

    private let spotListView = SpotListView()

    private let viewModel = SpotListViewModel()

    private let spotToggleButton = SpotToggleButtonView()

    private let filterButton = UIButton()

    private var isSkeletonShowing: Bool = true
    private var isDataLoading: Bool = true


    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        bindObservable()
        setCollectionView()
        addTarget()
        setSkeleton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        self.tabBarController?.tabBar.isHidden = false
        viewModel.startPeriodicLocationCheck()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ACToastController.hide()
        viewModel.stopPeriodicLocationCheck()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        spotToggleButton.refreshBlurEffect()

        for cell in spotListView.collectionView.visibleCells {
            if let cell = cell as? SpotListCollectionViewCell {
                cell.setNeedsLayout()
           }
       }
    }


    // MARK: - UI Settings

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
    }

}


// MARK: - Internal Methods

extension SpotListViewController {

    // NOTE: '장소' 탭 선택 시 호출
    func refreshSpotList() {
        handleRefreshControl()
    }

}


// MARK: - Bind VM, Observable

extension SpotListViewController {

    func bindViewModel() {
        viewModel.onSuccessPostSpotList.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }

            let spotList = viewModel.spotList

            if onSuccess {
                DispatchQueue.main.async {
                    self.isDataLoading = false
                    self.spotListView.regionErrorView.isHidden = true
                    self.spotListView.updateCollectionViewLayout(type: spotList.transportMode)
                    self.spotListView.collectionView.reloadData()
                    self.spotListView.collectionView.refreshControl?.endRefreshing()
                    self.spotListView.collectionView.setContentOffset(.zero, animated: true)
                }

                // NOTE: 스켈레톤 최소 1초 유지
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isSkeletonShowing = false
                    self.endSkeletonAnimation()
                }
            }

            // NOTE: 법정동 조회 실패 (서비스불가지역)
            else if viewModel.errorType == .unsupportedRegion {
                isSkeletonShowing = false
                isDataLoading = false
                endSkeletonAnimation()
                spotListView.regionErrorView.isHidden = false
            }

            else {
                isSkeletonShowing = false
                isDataLoading = false
                endSkeletonAnimation()
                // TODO: 네트워크 에러뷰, 버튼에 postSpotList() 액션 설정

            }
            
            viewModel.errorType = nil
            viewModel.onSuccessPostSpotList.value = nil
            
            filterButton.isSelected = !viewModel.filterList.isEmpty
            
            viewModel.onFinishRefreshingSpotList.value = true
        }
        
        viewModel.needToShowToast.bind { [weak self] isNeeded in
            guard let self = self,
                  let isNeeded = isNeeded else { return }
            
            if isNeeded {
                DispatchQueue.main.async { [weak self] in
                    ACToastController.show(
                        .locationChanged,
                        bottomInset: 85,
                        tapAction: {
                            self?.viewModel.postSpotList()
                            self?.startSkeletonAnimation()
                        }
                    )
                }
                spotListView.setNeedsLayout()
                spotListView.layoutIfNeeded()
            }
            viewModel.needToShowToast.value = nil
        }
    }

    func bindObservable() {
        spotToggleButton.selectedType.bind { [weak self] spotType in
            guard let self = self,
                  let spotType = spotType else { return }

            spotListView.collectionView.setContentOffset(.zero, animated: true)
            viewModel.spotType = spotType
            viewModel.filterList = []
            viewModel.updateLocationAndPostSpotList()
            startSkeletonAnimation()
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

        viewModel.updateLocationAndPostSpotList()
        startSkeletonAnimation()
    }

    @objc
    func tappedFilterButton() {
        guard AuthManager.shared.hasToken else {
            presentLoginModal(AmplitudeLiterals.EventName.filter)
            return
        }

        let vc = SpotListFilterViewController(viewModel: viewModel)
        vc.setSheetLayout(detent: .semiLong)

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
            NoMatchingSpotListCollectionViewCell.self,
            forCellWithReuseIdentifier: NoMatchingSpotListCollectionViewCell.cellIdentifier
        )

        spotListView.collectionView.register(
            SpotListGoogleAdCollectionViewCell.self,
            forCellWithReuseIdentifier: SpotListGoogleAdCollectionViewCell.cellIdentifier
        )

        spotListView.collectionView.register(
            SpotListSkeletonHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SpotListSkeletonHeader.identifier
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


// MARK: - Skeleton Controls

private extension SpotListViewController {

    func setSkeleton() {
        spotListView.collectionView.prepareSkeleton { _ in
        }
    }

    func startSkeletonAnimation() {
        DispatchQueue.main.async { [weak self] in
            self?.spotListView.collectionView.startACSkeletonAnimation(direction: .leftRight, duration: 1)
            self?.isSkeletonShowing = true
            self?.isDataLoading = true
        }
    }

    func endSkeletonAnimation() {
        isSkeletonShowing = false
        spotListView.hideSkeleton()
    }

}


// MARK: - CollectionView DataSource

extension SpotListViewController: UICollectionViewDataSource {

    // MARK: number of items

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.spotList.spotList.count
    }


    // MARK: cellForItemAt

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let spotList = viewModel.spotList

        switch spotList.transportMode {
        case .walking:
            if indexPath.item % 5 == 0 && indexPath.item > 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpotListGoogleAdCollectionViewCell.cellIdentifier, for: indexPath) as? SpotListGoogleAdCollectionViewCell else {
                    return UICollectionViewCell() }

                // TODO: 🍇 주석 해제 (실제 코드)
//                if let nativeAd = GoogleAdsManager.shared.getNativeAd(.imageOnly) {
//                    cell.configure(with: nativeAd)
//                } else {
                    cell.isSkeletonable = true
                    cell.startACSkeletonAnimation()
//                }
                
                return cell
            } else {
                return dequeueAndConfigureCell(
                    collectionView: collectionView,
                    cellType: SpotListCollectionViewCell.self,
                    at: indexPath,
                    with: spotList
                )
            }
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


    // MARK: Supplementary View

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard !isDataLoading else {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SpotListSkeletonHeader.identifier,
                for: indexPath) as? SpotListSkeletonHeader else {
                fatalError("Cannot dequeue skeleton header view")
            }
            return header
        }
        
        
        let spotList = viewModel.spotList

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


    // MARK: DidSelectItemAt

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.spotList.spotList[indexPath.item]
        let vc = SpotDetailViewController(item.id, item.tagList)

        if AuthManager.shared.hasToken {
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            presentLoginModal(AmplitudeLiterals.EventName.tappedSpotCell)
        }
    }

}


// MARK: - CollectionView FlowLayout

extension SpotListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard !isDataLoading else {
            return CGSize(width: SpotListItemSizeType.itemMaxWidth.value,
                          height: SpotListItemSizeType.headerHeight.value)
        }

        let spotList = viewModel.spotList

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


// MARK: - UIScrollView Delegate

extension SpotListViewController: UIScrollViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard !isDataLoading else { return }

        if viewModel.spotList.transportMode == .walking {
            let cellHeight = SpotListItemSizeType.itemMaxHeight.value + SpotListItemSizeType.minimumLineSpacing.value
            let targetY = targetContentOffset.pointee.y
            let newTargetY = round(targetY / cellHeight) * cellHeight + SpotListItemSizeType.minimumLineSpacing.value / 2

            // NOTE: 화면 중앙과 가장 가까운 셀을 찾아 화면 중앙으로 이동
            targetContentOffset.pointee = CGPoint(x: 0, y: newTargetY)
            HapticManager.shared.hapticSelection()
        }

        // NOTE: 네비게이션 바 글라스모피즘 On/Off
        if targetContentOffset.pointee.y > 0 {
            setGlassMorphism()
        } else {
            glassMorphismView.removeFromSuperview()
        }
    }

}


// MARK: - Skeleton CollectionView DataSource

extension SpotListViewController: SkeletonCollectionViewDataSource {

    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        return skeletonView.dequeueReusableCell(
            withReuseIdentifier: SpotListCollectionViewCell.cellIdentifier,
            for: indexPath
        )
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier? {
        return SpotListSkeletonHeader.identifier
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return SpotListCollectionViewCell.identifier
    }

}


// MARK: - SpotListCell Delegate

extension SpotListViewController: SpotListCellDelegate {

    func tappedFindCourseButton(spot: SpotModel) {
        guard AuthManager.shared.hasToken else {
            presentLoginModal(AmplitudeLiterals.EventName.tappedSpotCell)
            return
        }

        AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.mainMenu, properties: ["click_home_navigation?": true]) // TODO: guard문 위로 올릴지 기획 문의중

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.do { [weak self] in
            guard let self = self else { return }
            $0.addAction(UIAlertAction(title: StringLiterals.Map.naverMap, style: .default, handler: { _ in
                MapRedirectManager.shared.redirect(
                    to: MapRedirectModel(name: spot.name, latitude: spot.latitude, longitude: spot.longitude),
                    using: .naver)
                self.viewModel.postGuidedSpot(spotID: spot.id)
            }))
            $0.addAction(UIAlertAction(title: StringLiterals.Map.appleMap, style: .default, handler: { _ in
                MapRedirectManager.shared.redirect(
                    to: MapRedirectModel(name: spot.name, latitude: spot.latitude, longitude: spot.longitude),
                    using: .apple)
                self.viewModel.postGuidedSpot(spotID: spot.id)
            }))
            $0.addAction(UIAlertAction(title: StringLiterals.Alert.cancel, style: .cancel, handler: nil))
        }
        present(alertController, animated: true)
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
        cell.setFindCourseDelegate(self)
        cell.isSkeletonable = true

        return cell
    }

}
