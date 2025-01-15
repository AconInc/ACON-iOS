//
//  FavoriteSpotTypeCollectionView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/15/25.
//

import UIKit

import SnapKit
import Then

final class FavoriteSpotTypeCollectionView: UICollectionView {
    
    var selectedSpotType: String? {
        didSet {
            reloadData()
            if let selectedSpotType = selectedSpotType {
                onSelectionChanged?(selectedSpotType)
            }
        }
    }
    
    var onSelectionChanged: ((String) -> Void)?
    
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
        register(DislikeCollectionViewCell.self, forCellWithReuseIdentifier: BaseCollectionViewCell.cellIdentifier)
    }
}

extension FavoriteSpotTypeCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        let itemWidth = screenWidth * 0.42
        let itemHeight = screenHeight * 0.41
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return UIScreen.main.bounds.width * 0.01
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let horizontalInset = UIScreen.main.bounds.width * 0.06
        let verticalInset = UIScreen.main.bounds.width * 0.1
        return UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
}

extension FavoriteSpotTypeCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FavoriteSpotType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: BaseCollectionViewCell.cellIdentifier, for: indexPath) as? DislikeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let option = FavoriteSpotType.allCases[indexPath.row]
        let isSelected = selectedSpotType == option.mappedValue
        cell.checkConfigure(name: option.name, image: option.image, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedOption = FavoriteSpotType.allCases[indexPath.row]
        
        if selectedSpotType == selectedOption.mappedValue {
            selectedSpotType = nil
        } else {
            selectedSpotType = selectedOption.mappedValue
        }
    }
}
