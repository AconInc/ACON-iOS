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
    
    private let footerLabel = UILabel()
    
    
    // MARK: - LifeCycles
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(footerLabel,
                         collectionView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        footerLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-40)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(18)
            $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        setFooterLabel()
        setCollectionView()
    }
    
}


// MARK: - UI Settings

private extension SpotListView {
    
    func setFooterLabel() {
        let text = StringLiterals.SpotList.footerText
        footerLabel.setLabel(
            text: text,
            style: .b4,
            color: .gray5,
            alignment: .center
        )
    }
    
    func setCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        // NOTE: itemSize는 Controller에서 설정합니다. (collectionView의 height이 필요하기 때문)
        flowLayout.minimumLineSpacing = SpotListItemSizeType.minimumLineSpacing.value
        flowLayout.scrollDirection = .vertical
        
        collectionView.do {
            $0.backgroundColor = .clear
            $0.setCollectionViewLayout(flowLayout, animated: true)
        }
    }
    
}


// MARK: - Binding

extension SpotListView {
    
    func hideFooterLabel(isHidden: Bool) {
        footerLabel.isHidden = isHidden
        print("hideFooterLabel called.")
    }
    
}
