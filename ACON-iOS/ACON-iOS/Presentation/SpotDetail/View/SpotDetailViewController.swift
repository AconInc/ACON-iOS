//
//  SpotDetailViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/16/25.
//

import UIKit

import SnapKit
import Then

class SpotDetailViewController: BaseNavViewController, UICollectionViewDelegate {
    
    // MARK: - UI Properties
    
    private let spotDetailView = SpotDetailView()


    // MARK: - Properties
    
    // TODO: - 이거 spotID 전 화면에서 넘겨받는 것으로 변경
    private let spotDetailViewModel: SpotDetailViewModel
    
    private let spotDetailName: String = "가게명가게명"
    
    private let spotDetailType: String = "음식점"
    
    // MARK: - LifeCycle
    
    init(_ spotID: Int64) {
        self.spotDetailViewModel = SpotDetailViewModel(spotID: spotID)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
        registerCell()
        setDelegate()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        spotDetailViewModel.getSpotDetail()
        spotDetailViewModel.getSpotMenu()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.contentView.addSubview(spotDetailView)
    }
    
    override func setLayout() {
        super.setLayout()

        spotDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.applyGlassmorphism()
        self.setBackButton()
    }
    
    private func addTarget() {
        spotDetailView.findCourseButton.addTarget(self,
                                                  action: #selector(findCourseButtonTapped),
                                                  for: .touchUpInside)
        
        spotDetailView.gotoTopButton.addTarget(self,
                                               action: #selector(scrollToTopButtonTapped), for: .touchUpInside)
    }

}


// MARK: - bindViewModel

private extension SpotDetailViewController {
    
    func bindViewModel() {
        self.spotDetailViewModel.onSuccessGetSpotDetail.bind { [weak self] onSuccess in
            guard let onSuccess, let data = self?.spotDetailViewModel.spotDetail.value else { return }
            if onSuccess {
                self?.bindNavBar(data: data)
                self?.spotDetailView.bindData(data: data)
            }
        }
        
        self.spotDetailViewModel.onSuccessGetSpotMenu.bind { [weak self] onSuccess in
            guard let onSuccess, let data = self?.spotDetailViewModel.spotMenu.value else { return }
            if onSuccess {
                self?.spotDetailView.menuCollectionView.reloadData()
                self?.updateCollectionViewHeight()
            }
        }
        
    }
    
}

// MARK: - @objc methods

private extension SpotDetailViewController {
    
    @objc
    func findCourseButtonTapped() {
        spotDetailViewModel.postGuidedSpot()
        spotDetailViewModel.redirectToNaverMap()
    }
    
    @objc
    private func scrollToTopButtonTapped() {
        spotDetailView.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
}

// MARK: - setUI

private extension SpotDetailViewController {
    
    func bindNavBar(data: SpotDetailInfoModel) {
        self.secondTitleLabel.do {
            $0.isHidden = false
            $0.setPartialText(fullText: data.name+" "+data.spotType, textStyles: [(data.name+" ", .t2, .acWhite), (data.spotType, .b2, .acWhite)])
        }
    }
    
}

// MARK: - CollectionView Setting Methods

private extension SpotDetailViewController {
    
    func registerCell() {
        spotDetailView.menuCollectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.cellIdentifier)
    }
    
    func setDelegate() {
        spotDetailView.menuCollectionView.delegate = self
        spotDetailView.menuCollectionView.dataSource = self
        spotDetailView.scrollView.delegate = self
    }
    
    func updateCollectionViewHeight() {
        let numberOfItems = spotDetailViewModel.spotMenu.value?.count
        let itemHeight = SpotDetailView.menuCollectionViewFlowLayout.itemSize.height
        let totalHeight = itemHeight * CGFloat(numberOfItems ?? 0)
        
        spotDetailView.menuCollectionView.snp.updateConstraints {
            $0.height.equalTo(totalHeight)
        }
        
        spotDetailView.scrollContentView.layoutIfNeeded()
    }
    
}


// MARK: - CollectionView DataSource

extension SpotDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spotDetailViewModel.spotMenu.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = spotDetailViewModel.spotMenu.value?[indexPath.item] else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.cellIdentifier, for: indexPath) as? MenuCollectionViewCell else {
            return UICollectionViewCell() }
        cell.dataBind(data, indexPath.item)
        return cell
    }
    
}


// MARK: - Enable Sticky Header

extension SpotDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //NOTE: - 내 맘대로 -68 함 (높이 36이라 72 해야할 것 같은데 아무튼 추후수정
        let stickyPosition = ScreenUtils.heightRatio*400 + ScreenUtils.navViewHeight - 68
        let shouldShowSticky = scrollView.contentOffset.y >= stickyPosition
        spotDetailView.stickyView.isHidden = !shouldShowSticky
        spotDetailView.stickyHeaderView.isHidden = shouldShowSticky
        
        let shouldShowBlurSpotImageView = spotDetailView.scrollView.contentOffset.y > ScreenUtils.navViewHeight
        spotDetailView.blurSpotImageView.isHidden = shouldShowBlurSpotImageView
    }

}
