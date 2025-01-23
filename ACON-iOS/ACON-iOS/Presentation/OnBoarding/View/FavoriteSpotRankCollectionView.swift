//
//  FavoriteSpotRankCollectionView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/15/25.
//

import UIKit

import SnapKit
import Then

final class FavoriteSpotRankCollectionView: UICollectionView {
    
    var selectedIndices: [String] = [] {
        didSet {
            reloadData()
            print(selectedIndices)
            onSelectionChanged?(selectedIndices)
        }
    }
    
    var onSelectionChanged: (([String]) -> Void)?
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        setStyle()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        isScrollEnabled = false
    }
    
    private func setDelegate() {
        delegate = self
        dataSource = self
        register(
            BigBoxViewCell.self,
            forCellWithReuseIdentifier: BaseCollectionViewCell.cellIdentifier
        )
    }
    
}

extension FavoriteSpotRankCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemWidth = ScreenUtils.widthRatio * 158
        let itemHeight = itemWidth * 1.2
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return ScreenUtils.heightRatio * 12
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return ScreenUtils.widthRatio * 6
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let horizontalInset = ScreenUtils.width * 14 / 360
        let verticalInset = ScreenUtils.width * 84 / 780
        return UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: 0,
            right: horizontalInset
        )
    }

}

extension FavoriteSpotRankCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return FavoriteSpotRankType.allCases.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: BaseCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? BigBoxViewCell else {
            return UICollectionViewCell()
        }
        
        let option = FavoriteSpotRankType.allCases[indexPath.row]
        
        let isSelected = selectedIndices.firstIndex(of: option.mappedValue).map { $0 + 1 } ?? 0
        
        cell.configure(name: option.name, image: option.image, isSelected: isSelected)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let selectedOption = FavoriteSpotRankType.allCases[indexPath.row]
        
        if let index = selectedIndices.firstIndex(of: selectedOption.mappedValue) {
            selectedIndices.remove(at: index)
        } else if selectedIndices.count < 4 {
            selectedIndices.append(selectedOption.mappedValue)
        } else {
            print("최대 4개까지만 선택 가능")
        }
    }
    
}
