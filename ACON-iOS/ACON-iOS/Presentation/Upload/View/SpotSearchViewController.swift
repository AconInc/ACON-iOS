//
//  SpotSearchViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import UIKit

import SnapKit
import Then

class SpotSearchViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let spotSearchView = SpotSearchView()


    // MARK: - Properties
    
    private let spotSearchViewModel = SpotSearchViewModel()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        addTarget()
        registerCell()
        setDelegate()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.contentView.addSubview(spotSearchView)
    }
    
    override func setLayout() {
        super.setLayout()

        spotSearchView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        setRecommendedSpotStackView(data: spotSearchViewModel.recommendedSearchDummyData)
    }
    
    func addTarget() {
        spotSearchView.doneButton.addTarget(self,
                                              action: #selector(doneButtonTapped),
                                              for: .touchUpInside)
    }

}

    
// MARK: - @objc functions

extension SpotSearchViewController {
    
    @objc
    func doneButtonTapped() {
        self.dismiss(animated: true)
    }
    
}


// MARK: - Set UI

private extension SpotSearchViewController {
    
    func setRecommendedSpotStackView(data: RecommendedSearchModel) {
        for i in 0...4 {
            let button = spotSearchView.makeRecommendedSpotButton(data.spotList[i])
            spotSearchView.recommendedSpotStackView.addArrangedSubview(button)
        }
    }
    
}


// MARK: - CollectionView Setting Methods

private extension SpotSearchViewController {
    
    func registerCell() {
        spotSearchView.relatedSearchCollectionView.register(RelatedSearchCollectionViewCell.self, forCellWithReuseIdentifier: RelatedSearchCollectionViewCell.cellIdentifier)
    }
    
    func setDelegate() {
        spotSearchView.relatedSearchCollectionView.delegate = self
        spotSearchView.relatedSearchCollectionView.dataSource = self
    }
    
}


// MARK: - CollectionView Delegate

extension SpotSearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return SpotSearchView.relatedSearchCollectionViewFlowLayout.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: ScreenUtils.width * 0.112, bottom: 0, right: ScreenUtils.width * 0.112)
    }
    
}


// MARK: - CollectionView DataSource

extension SpotSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = spotSearchViewModel.relatedSearchDummyData[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelatedSearchCollectionViewCell.cellIdentifier, for: indexPath) as? RelatedSearchCollectionViewCell else {
            return UICollectionViewCell() }
        cell.dataBind(data, indexPath.item)
        return cell
    }
    
}
