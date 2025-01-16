//
//  DislikeCollectionView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/15/25.
//

import UIKit

import SnapKit
import Then

final class DislikeCollectionView: UICollectionView {
    
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

extension DislikeCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemWidth = ScreenUtils.width * 101 / 360
        let itemHeight = itemWidth * 1.277
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return ScreenUtils.height * 12 / 780
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return ScreenUtils.width * 8 / 360
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let horizontalInset = ScreenUtils.width * 10 / 360
        return UIEdgeInsets(
            top: 0,
            left: horizontalInset,
            bottom: 0,
            right: horizontalInset
        )
    }
    
}

extension DislikeCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return DislikeType.allCases.count
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
        let option = DislikeType.allCases[indexPath.row]
        let isSelected = selectedIndices.contains(option.mappedValue)
        cell.checkConfigure(
            name: option.name,
            image: option.image,
            isSelected: isSelected
        )
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let selectedOption = DislikeType.allCases[indexPath.row]
        
        if selectedOption == .none {
            selectedIndices = selectedIndices == [selectedOption.mappedValue]
                ? []
                : [selectedOption.mappedValue]
        } else {
            if selectedIndices.contains(DislikeType.none.mappedValue) {
                selectedIndices.removeAll()
            }
            
            if selectedIndices.contains(selectedOption.mappedValue) {
                selectedIndices.removeAll { $0 == selectedOption.mappedValue }
            } else if selectedIndices.count < 5 {
                selectedIndices.append(selectedOption.mappedValue)
            } else {
                print("최대 5개까지만 선택 가능합니다.")
            }
        }
    }
    
}
