//
//  SpotListView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/12/25.
//

import UIKit

class SpotListView: BaseView {
    
    // MARK: - UI Properties
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    
    // MARK: - LifeCycles
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(collectionView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        self.backgroundColor = .gray9
        
        setCollectionView()
    }
}


// MARK: - UI Settings

extension SpotListView {
    func setCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        let width: CGFloat = ScreenUtils.width - 40
        let height: CGFloat = 408
        
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.minimumLineSpacing = 12
        flowLayout.scrollDirection = .vertical
        
        collectionView.do {
            $0.setCollectionViewLayout(flowLayout, animated: true)
        }
    }
    
}
