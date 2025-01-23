//
//  SpotListViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/11/25.
//

import UIKit

class SpotListViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let glassMorphismView = GlassmorphismView()
    
    private let spotListView = SpotListView()
    
    
    // MARK: - Properties
    
    private let spotListView = SpotListView()
    private let viewModel = SpotListViewModel()
    
    private var selectedSpotCondition: SpotConditionModel = SpotConditionModel(spotType: .restaurant, filterList: [], walkingTime: -1, priceRange: -1)
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setCollectionView()
        addTarget()
        
        viewModel.requestLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        handleRefreshControl()
        self.tabBarController?.tabBar.isHidden = false
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
        setGlassMorphism()
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
    
}


// MARK: - Bind ViewModel

extension SpotListViewController {
    
    func bindViewModel() {
        
        viewModel.isPostSpotListSuccess.bind { [weak self] isSuccess in
            guard let self = self,
                  let isSuccess = isSuccess else { return }
            if isSuccess {
                print("🥑\(viewModel.isUpdated)")
                if viewModel.isUpdated {
                    spotListView.collectionView.reloadData()
                    print("🥑reloadData")
                } else {
                    print("🥑데이터가 안 바뀌어서 리로드데이터 안 함")
                }
            } else {
                print("🥑Post 실패")
            }
            viewModel.isUpdated = false
            viewModel.isPostSpotListSuccess.value = nil
            endRefreshingAndTransparancy()
            
            let isFilterSet = !viewModel.filterList.isEmpty
            spotListView.updateFilterButtonColor(isFilterSet)
        }
    }
    
}


// MARK: - 글라스모피즘 - BaseNavVC에 넣으면 오류 떠서 우선 여기에
// TODO: - 추후 BaseNavVC로 빼기

private extension SpotListViewController {
    
    func setGlassMorphism() {
        self.view.insertSubview(glassMorphismView, aboveSubview: contentView)
        glassMorphismView.snp.makeConstraints {
            $0.top.equalTo(topInsetView)
            $0.bottom.horizontalEdges.equalTo(navigationBarView)
        }
    }
    
}


// MARK: - @objc functions

private extension SpotListViewController {
    
    @objc
    func handleRefreshControl() {
        viewModel.requestLocation()
        
        DispatchQueue.main.async {
            // NOTE: 데이터 리로드 전 애니메이션
            UIView.animate(withDuration: 0.25, animations: {
                self.spotListView.collectionView.alpha = 0.5 // 투명도 낮춤
            }) { _ in
                
                self.viewModel.postSpotList()
            }
        }
    }
    
    @objc
    func tappedFilterButton() {
        let vc = SpotListFilterViewController(viewModel: viewModel)
        vc.setLongSheetLayout()
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
        
        spotListView.collectionView.register(
            SpotListCollectionViewFooter.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: SpotListCollectionViewFooter.identifier)
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
        let vc = SpotDetailViewController(1) // TODO: 1 -> item.id로 변경
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - 글라스모피즘 스크롤 시 선택
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
           
        if offset > 0 {
            [topInsetView, navigationBarView].forEach {
                $0.backgroundColor = .clear
            }
            glassMorphismView.isHidden = false
        } else {
            [topInsetView, navigationBarView].forEach {
                $0.backgroundColor = .gray9
            }
            glassMorphismView.isHidden = true
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
