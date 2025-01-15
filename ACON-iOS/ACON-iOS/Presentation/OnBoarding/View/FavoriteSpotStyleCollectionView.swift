//
//  FavoriteSpotStyleCollectionView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/15/25.
//

import UIKit

import SnapKit
import Then

final class FavoriteSpotStyleCollectionView: UICollectionView {
    
    var selectedStyle: String? {
        didSet {
            reloadData()
            if let selectedStyle = selectedStyle {
                onSelectionChanged?(selectedStyle)
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

extension FavoriteSpotStyleCollectionView: UICollectionViewDelegateFlowLayout {
    
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

extension FavoriteSpotStyleCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FavoriteSpotStyle.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: BaseCollectionViewCell.cellIdentifier, for: indexPath) as? DislikeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let option = FavoriteSpotStyle.allCases[indexPath.row]
        let isSelected = selectedStyle == option.mappedValue
        cell.checkConfigure(name: option.name, image: option.image, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedOption = FavoriteSpotStyle.allCases[indexPath.row]
        
        if selectedStyle == selectedOption.mappedValue {
            selectedStyle = nil
        } else {
            selectedStyle = selectedOption.mappedValue
        }
    }
}
