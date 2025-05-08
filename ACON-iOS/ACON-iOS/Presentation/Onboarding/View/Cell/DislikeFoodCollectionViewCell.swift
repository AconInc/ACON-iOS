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
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let width = chipButton.intrinsicContentSize.width + 24
        
        var newFrame = layoutAttributes.frame
        newFrame.size.width = width
        newFrame.size.height = 38
        layoutAttributes.frame = newFrame
        
        return layoutAttributes
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.chipButton.updateGlassButtonState(state: .selected)
            } else {
                self.chipButton.updateGlassButtonState(state: .default)
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.chipButton.updateGlassButtonState(state: .pressed)
            } else {
                self.chipButton.updateGlassButtonState(state: .default)
            }
        }
    }
    
    //TODO: - chipButton 글모 하얗게디자인 제대로 안 뜨는 문제 !!!!!!!!! + 셀 선택 안됨
    
}

extension DislikeFoodCollectionViewCell {
    
    func bindData(_ title: String?, _ indexRow: Int) {
        chipButton.updateGlassButtonTitle(title ?? "")
    }
    
}
