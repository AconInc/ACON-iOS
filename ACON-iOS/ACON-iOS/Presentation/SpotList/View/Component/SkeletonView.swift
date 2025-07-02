//
//  SkeletonView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/24/25.
//

import UIKit

class SkeletonView: BaseView {
    
    // MARK: - Properties
    
    private let stackView = UIStackView()
    
    
    // MARK: - Initializer

    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(stackView)
    }

    override func setLayout() {
        super.setLayout()
        
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.backgroundColor = .gray900
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 12
        }
        
        addContentViews()
    }
    
    private func addContentViews() {
        stackView.addArrangedSubview(makeLongCollectionView())
        
        for _ in 1...4 {
            stackView.addArrangedSubview(makeSmallContentView())
        }
    }
    
    private func makeLongCollectionView() -> UIView {
        let longView = UIView()
        
        longView.do {
            $0.backgroundColor = .gray700
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 6
            $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        }
        
        longView.snp.makeConstraints {
            $0.width.equalTo(SpotListItemSizeType.itemMaxWidth.value)
            $0.height.equalTo(SpotListItemSizeType.itemMaxHeight.value)
        }
        
        return longView
    }
    
    private func makeSmallContentView() -> UIView {
        let smallView = UIView()
        
        smallView.do {
            $0.backgroundColor = .gray700
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 6
        }
        
        smallView.snp.makeConstraints {
            $0.width.equalTo(SpotListItemSizeType.itemMaxWidth.value)
            $0.height.equalTo(SpotListItemSizeType.itemMinHeight.value)
        }
        
        return smallView
    }
    
}
