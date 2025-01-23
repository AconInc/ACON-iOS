//
//  FavoriteCuisineCollectionView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/15/25.
//

import UIKit

import SnapKit
import Then

final class FavoriteCuisineCollectionView: UICollectionView {
    
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
    }
    
    private func setDelegate() {
        delegate = self
        dataSource = self
        register(
            SmallBoxViewCell.self,
            forCellWithReuseIdentifier: BaseCollectionViewCell.cellIdentifier
        )
    }
    
}

extension FavoriteCuisineCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemWidth = ScreenUtils.widthRatio * 101
        let itemHeight = itemWidth * 1.277
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
        return ScreenUtils.widthRatio * 8
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let horizontalInset = ScreenUtils.widthRatio * 10
        let verticalInset = ScreenUtils.width * 84 / 780
        return UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: 0,
            right: horizontalInset
        )
    }
    
}

extension FavoriteCuisineCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return FavoriteCuisineType.allCases.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: BaseCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? SmallBoxViewCell else {
            return UICollectionViewCell()
        }
        
        let option = FavoriteCuisineType.allCases[indexPath.row]
        
        // NOTE: 터치한 순서를 기반으로 index를 설정
        let isSelected = selectedIndices.firstIndex(of: option.mappedValue).map { $0 + 1 } ?? 0
        
        let isDimmed = selectedIndices.count >= 3 && !selectedIndices.contains(option.mappedValue)

        cell.configure(name: option.name,
                       image: option.image,
                       isSelected: isSelected,
                       isDimmed: isDimmed)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let selectedOption = FavoriteCuisineType.allCases[indexPath.row]

        if selectedIndices.contains(selectedOption.mappedValue) {
            selectedIndices.removeAll { $0 == selectedOption.mappedValue }
        } else if selectedIndices.count < 3 {
            selectedIndices.append(selectedOption.mappedValue)
        } else {
            print("최대 3개까지만 선택 가능합니다.")
        }
    }
    
}
