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
    
    private let options: [(name: String, image: UIImage?)] = [
        ("분위기와 인테리어가\n감각적인 곳", UIImage(named: "moodPlace") ?? UIImage(systemName: "photo")),
        ("새로운 음식을\n 경험할 수 있는 곳", UIImage(named: "newPlace") ?? UIImage(systemName: "photo")),
        ("가격과 양이 합리적인 곳", UIImage(named: "qualityPlace") ?? UIImage(systemName: "photo")),
        ("특별한 날을 위한 고급스러운 장소", UIImage(named: "specialPlace") ?? UIImage(systemName: "photo"))
    ]
    
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
        register(FavoriteCuisineCollectionViewCell.self, forCellWithReuseIdentifier: "FavoriteCuisineCollectionViewCell")
    }
}

extension FavoriteSpotRankCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth * 0.427
        let itemHeight = itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return UIScreen.main.bounds.width * 0.04
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return UIScreen.main.bounds.width * 0.02
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let horizontalInset = UIScreen.main.bounds.width * 0.04
        let verticalInset = UIScreen.main.bounds.width * 0.1
        return UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
}

extension FavoriteSpotRankCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: "FavoriteCuisineCollectionViewCell",
            for: indexPath
        ) as? FavoriteCuisineCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let option = options[indexPath.row]
        let isSelected = selectedIndices.firstIndex(of: Mappings.favoriteSpotRanks[indexPath.row]).map { $0 + 1 } ?? 0
        cell.configure(name: option.name, image: option.image, isSelected: isSelected)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedValue = Mappings.favoriteSpotRanks[indexPath.row]
        
        if let index = selectedIndices.firstIndex(of: selectedValue) {
            selectedIndices.remove(at: index)
        } else if selectedIndices.count < 4 {
            selectedIndices.append(selectedValue)
        } else {
            print("최대 4개까지만 선택 가능")
        }
    }
    
    
}
