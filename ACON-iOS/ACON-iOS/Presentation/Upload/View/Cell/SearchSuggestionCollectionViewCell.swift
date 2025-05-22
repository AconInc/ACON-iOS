//
//  SearchSuggestionCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/15/25.
//

import UIKit
// TODO: - DislikeCollectionViewCell과 bindData 제외 같음, 구조 고민해보기
// TODO: - 🆘 chipButton이 하얗게 있다가 default로 세팅되는 게 보임. 타이밍 고민
final class SearchSuggestionCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Properties
    
    private var chipButton : ACButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_19_b1R))

    
    // MARK: - Properties

    /// 그냥 isSelected 사용 시 didSelectItems 때 무조건 true 돼서 싱크 안 맞음
    var isChipSelected: Bool {
        didSet {
            if isChipSelected {
                self.chipButton.updateGlassButtonState(state: .selected)
            } else {
                self.chipButton.updateGlassButtonState(state: .default)
            }
        }
    }
    
    var isChipEnabled: Bool {
        didSet {
            if isChipEnabled {
                self.chipButton.updateGlassButtonState(state: .default)
            } else {
                self.chipButton.updateGlassButtonState(state: .disabled)
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
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        self.isChipSelected = false
        self.isChipEnabled = true
        
        super.init(frame: frame)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        self.isSelected = false
        chipButton.isUserInteractionEnabled = false
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let width = chipButton.intrinsicContentSize.width + 24
        
        var newFrame = layoutAttributes.frame
        newFrame.size.width = width
        newFrame.size.height = 38
        layoutAttributes.frame = newFrame
        
        return layoutAttributes
    }

}

extension SearchSuggestionCollectionViewCell {
    
    func bindData(_ title: String?, _ indexRow: Int) {
        chipButton.updateButtonTitle(title ?? "")
        self.setNeedsLayout()
        self.layoutIfNeeded()

        DispatchQueue.main.async {
            self.chipButton.updateGlassButtonState(state: .default)
        }
    }
    
}
