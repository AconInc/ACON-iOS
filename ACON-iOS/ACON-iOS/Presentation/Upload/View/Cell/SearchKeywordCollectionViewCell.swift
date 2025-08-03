//
//  SearchKeywordCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/14/25.
//

import UIKit

import SnapKit
import Then

final class SearchKeywordCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Properties
    
    private let spotNameLabel: UILabel = UILabel()
    
    private let spotAddressLabel: UILabel = UILabel()
    
    private let spotTypeLabel: UILabel = UILabel()
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(spotNameLabel,
                         spotAddressLabel,
                         spotTypeLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        spotNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*12)
            $0.leading.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.height.equalTo(24)
            $0.width.equalTo(ScreenUtils.widthRatio*256)
        }
        
        spotAddressLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.heightRatio*12)
            $0.leading.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.height.equalTo(24)
            $0.width.equalTo(ScreenUtils.widthRatio*256)
        }
        
        spotTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*12)
            $0.trailing.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.height.equalTo(20)
            $0.width.equalTo(ScreenUtils.widthRatio*40)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.backgroundColor = .clear
    }
    
    // MARK: - 직접 셀 select
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let collectionView = superview as? UICollectionView,
           let indexPath = collectionView.indexPath(for: self) {
            collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
        }
    }

}

extension SearchKeywordCollectionViewCell {
    
    func bindData(_ relatedSearchData: SearchKeywordModel?, _ indexRow: Int) {
        spotNameLabel.setLabel(text: relatedSearchData?.spotName ?? "",
                               style: .t4R)
        spotAddressLabel.setLabel(text: relatedSearchData?.spotAddress ?? "",
                                  style: .b1R,
                                  color: .gray500)
        spotTypeLabel.setLabel(text: relatedSearchData?.spotType ?? "",
                              style: .b1R,
                               color: .gray500,
                               alignment: .right)
    }
    
}
