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
    
    private let options: [(name: String, image: UIImage?)] = [
        ("닭발", UIImage(named: "ChickenFeet") ?? UIImage(systemName: "photo")),
        ("회/육회", UIImage(named: "SashimiAndTartare") ?? UIImage(systemName: "photo")),
        ("곱창/대창/막창", UIImage(named: "IntestinesCombo") ?? UIImage(systemName: "photo")),
        ("순대/선지", UIImage(named: "BloodSausageSoup") ?? UIImage(systemName: "photo")),
        ("양고기", UIImage(named: "Lamb") ?? UIImage(systemName: "photo")),
        ("없음", UIImage(named: "None") ?? UIImage(systemName: "photo"))
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
        register(DislikeCollectionViewCell.self, forCellWithReuseIdentifier: "DislikeCollectionViewCell")
    }
}

extension DislikeCollectionView: UICollectionViewDelegateFlowLayout {
    
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

extension DislikeCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: "DislikeCollectionViewCell", for: indexPath) as? DislikeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let option = options[indexPath.row]
        let isSelected = selectedIndices.contains(Mappings.dislikeOptions[indexPath.row])
        cell.configure(name: option.name, image: option.image, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedValue = Mappings.dislikeOptions[indexPath.row]
        
        if selectedValue == "NONE" {
            selectedIndices = selectedIndices == ["NONE"] ? [] : ["NONE"]
        } else {
            if selectedIndices.contains("NONE") {
                selectedIndices.removeAll()
            }
            
            if selectedIndices.contains(selectedValue) {
                selectedIndices.removeAll { $0 == selectedValue }
            } else if selectedIndices.count < 5 {
                selectedIndices.append(selectedValue)
            } else {
                print("최대 5개까지만 선택 가능합니다.")
            }
        }
    }
}
