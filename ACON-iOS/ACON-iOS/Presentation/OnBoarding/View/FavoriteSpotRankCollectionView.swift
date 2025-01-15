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
        register(OnboardingCell.self, forCellWithReuseIdentifier: BaseCollectionViewCell.cellIdentifier)
    }
}

extension FavoriteSpotRankCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = ScreenUtils.width * 154 / 360
        let itemHeight = itemWidth * 1.2
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ScreenUtils.width * 3 / 360
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let horizontalInset = ScreenUtils.width * 20 / 360
        return UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
    }

}

extension FavoriteSpotRankCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FavoriteSpotRankType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: BaseCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? OnboardingCell else {
            return UICollectionViewCell()
        }
        
        let option = FavoriteSpotRankType.allCases[indexPath.row]
        
        // 선택된 순서 계산 (0 = 선택되지 않음)
        let isSelected = selectedIndices.firstIndex(of: option.mappedValue).map { $0 + 1 } ?? 0
        
        // `isSelected`를 Int로 전달
        cell.configure(name: option.name, image: option.image, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

import SwiftUI

struct FavoriteSpotRankCollectionViewPreview: UIViewRepresentable {
    
    func makeUIView(context: Context) -> FavoriteSpotRankCollectionView {
        // FavoriteSpotRankCollectionView 초기화
        let collectionView = FavoriteSpotRankCollectionView()
        
        // 뷰 크기 설정
        collectionView.frame = CGRect(
            origin: .zero,
            size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
        )
        
        // 샘플 데이터 설정
        collectionView.selectedIndices = ["SENSE", "NEW_FOOD"] // 초기 선택 상태
        collectionView.onSelectionChanged = { selectedIndices in
            print("선택된 항목: \(selectedIndices)")
        }
        
        return collectionView
    }
    
    func updateUIView(_ uiView: FavoriteSpotRankCollectionView, context: Context) {
        // 필요 시 업데이트 로직 추가
    }
}

struct FavoriteSpotRankCollectionViewPreview_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteSpotRankCollectionViewPreview()
            .edgesIgnoringSafeArea(.all)
            .previewLayout(.sizeThatFits)
    }
}
