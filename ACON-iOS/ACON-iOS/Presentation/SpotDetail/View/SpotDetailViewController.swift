//
//  SpotDetailViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/16/25.
//

import UIKit

import SnapKit
import Then

class SpotDetailViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let spotDetailView = SpotDetailView()


    // MARK: - Properties
    
    private let spotDetailViewModel = SpotDetailViewModel()
    
    private let spotDetailName: String = "가게명가게명"
    
    private let spotDetailType: String = "음식점"
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
        registerCell()
        setDelegate()
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
        
        self.setBackButton()
        updateCollectionViewHeight()
        bindNavBar(data: spotDetailViewModel.spotDetailDummyData)
        spotDetailView.bindData(data: spotDetailViewModel.spotDetailDummyData)
    }
    
    func addTarget() {
        spotDetailView.findCourseButton.addTarget(self,
                                              action: #selector(findCourseButtonTapped),
                                              for: .touchUpInside)
    }

}


// MARK: - @objc methods

private extension SpotDetailViewController {
    
    @objc
    func findCourseButtonTapped() {
        spotDetailViewModel.redirectToNaverMap(spotName: spotDetailName,
                                               latitude: 37.556944,
                                               longitude: 126.923917)
    }
    
}

// MARK: - setUI

private extension SpotDetailViewController {
    
    func bindNavBar(data: SpotDetail) {
        self.secondTitleLabel.do {
            $0.isHidden = false
            $0.setPartialText(fullText: data.name+" "+data.spotType, textStyles: [(data.name+" ", .t2, .acWhite), (data.spotType, .b2, .gray4)])
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
        let numberOfItems = spotDetailViewModel.menuDummyData.count
        let itemHeight = SpotDetailView.menuCollectionViewFlowLayout.itemSize.height
        let totalHeight = itemHeight * CGFloat(numberOfItems)
        
        spotDetailView.menuCollectionView.snp.updateConstraints {
            $0.height.equalTo(totalHeight)
        }
        
        spotDetailView.scrollContentView.layoutIfNeeded()
    }
    
}


// MARK: - CollectionView Delegate

extension SpotDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return SpotDetailView.menuCollectionViewFlowLayout.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
}


// MARK: - CollectionView DataSource

extension SpotDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spotDetailViewModel.menuDummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = spotDetailViewModel.menuDummyData[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.cellIdentifier, for: indexPath) as? MenuCollectionViewCell else {
            return UICollectionViewCell() }
        cell.dataBind(data, indexPath.item)
        return cell
    }
    
}


// MARK: - Enable Sticky Header

extension SpotDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(spotDetailView.scrollView.contentOffset.y, spotDetailView.stickyHeaderView.frame.minY)
        let shouldShowSticky = spotDetailView.scrollView.contentOffset.y >= spotDetailView.stickyHeaderView.frame.minY
        spotDetailView.stickyView.isHidden = !shouldShowSticky
        spotDetailView.stickyHeaderView.isHidden = shouldShowSticky
    }

}
