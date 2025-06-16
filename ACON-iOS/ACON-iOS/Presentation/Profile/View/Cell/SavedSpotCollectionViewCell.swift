//
//  SavedSpotCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/7/25.
//

import UIKit

import SkeletonView

final class SavedSpotCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Properties

    private let savedSpotView = SavedSpotView()
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        contentView.addSubviews(savedSpotView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        savedSpotView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.isSkeletonable = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        savedSpotView.cleanView()
    }
    
}


// MARK: - Bind Data

extension SavedSpotCollectionViewCell {
    
    func bindData(_ data: SavedSpotModel) {
        savedSpotView.bindData(data)
    }
    
}
