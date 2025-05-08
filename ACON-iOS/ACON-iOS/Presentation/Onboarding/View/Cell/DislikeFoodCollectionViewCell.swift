//
//  DislikeFoodCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/8/25.
//

import UIKit

final class DislikeFoodCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Properties
    
    private var chipButton : ACButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_100_b1R))
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubview(chipButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        chipButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.backgroundColor = .clear
        chipButton.do {
            $0.updateGlassButtonState(state: .default)
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let width = chipButton.intrinsicContentSize.width + 24
        
        var newFrame = layoutAttributes.frame
        newFrame.size.width = width
        newFrame.size.height = 38
        layoutAttributes.frame = newFrame
        
        return layoutAttributes
    }

    //TODO: - ACButton 글모 디자인 제대로 안 뜨는 문제 !!!!!!!!!
    override func layoutSubviews() {
        super.layoutSubviews()
        
        chipButton.frame = self.bounds
    }
    
}

extension DislikeFoodCollectionViewCell {
    
    func bindData(_ title: String?, _ indexRow: Int) {
        chipButton.updateGlassButtonTitle(title ?? "")
    }
    
}
