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
    
    private let options: [(name: String, image: UIImage?)] = [
        ("노포", UIImage(named: "nopo") ?? UIImage(systemName: "photo")),
        ("모던", UIImage(named: "modern") ?? UIImage(systemName: "photo"))
    ]
    
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
        register(DislikeCollectionViewCell.self, forCellWithReuseIdentifier: "DislikeCollectionViewCell")
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
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: "DislikeCollectionViewCell", for: indexPath) as? DislikeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let option = options[indexPath.row]
        let isSelected = selectedStyle == Mappings.favoriteSpotStyles[indexPath.row]
        cell.configure(name: option.name, image: option.image, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedValue = Mappings.favoriteSpotStyles[indexPath.row]
        
        if selectedStyle == selectedValue {
            selectedStyle = nil
        } else {
            selectedStyle = selectedValue
        }
    }
}
