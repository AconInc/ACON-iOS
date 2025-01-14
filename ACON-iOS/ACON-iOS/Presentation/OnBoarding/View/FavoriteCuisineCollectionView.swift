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
    
    private let options: [(name: String, image: UIImage?)] = [
        ("한식", UIImage(named: "koreanFood") ?? UIImage(systemName: "photo")),
        ("양식", UIImage(named: "westFood") ?? UIImage(systemName: "photo")),
        ("중식", UIImage(named: "chineseFood") ?? UIImage(systemName: "photo")),
        ("일식", UIImage(named: "japaneseFood") ?? UIImage(systemName: "photo")),
        ("분식", UIImage(named: "bunsic") ?? UIImage(systemName: "photo")),
        ("아시안", UIImage(named: "asianFood") ?? UIImage(systemName: "photo"))
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

extension FavoriteCuisineCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth * 0.28
        let itemHeight = itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return UIScreen.main.bounds.width * 0.08
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return UIScreen.main.bounds.width * 0.02
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let horizontalInset = UIScreen.main.bounds.width * 0.02
        let verticalInset = UIScreen.main.bounds.width * 0.1
        return UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
}

extension FavoriteCuisineCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: "FavoriteCuisineCollectionViewCell", for: indexPath) as? FavoriteCuisineCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let option = options[indexPath.row]
        
        // 터치한 순서를 기반으로 index를 설정
        let isSelected = selectedIndices.firstIndex(of: Mappings.favoriteCuisines[indexPath.row]).map { $0 + 1 } ?? 0
        
        cell.configure(name: option.name, image: option.image, isSelected: isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedValue = Mappings.favoriteCuisines[indexPath.row]

        if selectedIndices.contains(selectedValue) {
            // 이미 선택된 항목이면 배열에서 제거
            selectedIndices.removeAll { $0 == selectedValue }
        } else if selectedIndices.count < 3 {
            // 최대 3개까지만 선택 가능: 새로운 값을 추가
            selectedIndices.append(selectedValue)
        } else {
            print("최대 3개까지만 선택 가능합니다.")
        }
        
        // 선택된 값을 터치 순서대로 유지
        print("현재 선택된 값: \(selectedIndices)")
    }


}
