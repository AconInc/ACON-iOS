//
//  VerifiedAreasCollectionViewCell.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/1/25.
//

import UIKit

final class VerifiedAreasCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Propertires
    
    private let glassmorphismView: GlassmorphismView = GlassmorphismView(.buttonGlassDefault)

    private let label = UILabel()

    let deleteButton = UIButton()
    
    
    // MARK: - Properties
    
    var verifiedArea: VerifiedAreaModel? = nil


    // MARK: - UI Setting Methods

    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(glassmorphismView,
                         label,
                         deleteButton)
    }

    override func setLayout() {
        glassmorphismView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.verticalEdges.equalToSuperview().inset(9)
        }

        deleteButton.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
    }

    override func setStyle() {
        self.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 19
        }
        
        deleteButton.do {
            $0.setImage(.icClear, for: .normal)
        }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let width = deleteButton.isHidden ? label.intrinsicContentSize.width + 24 : label.intrinsicContentSize.width + 28 + 24
        
        var newFrame = layoutAttributes.frame
        newFrame.size.width = width
        newFrame.size.height = 38
        layoutAttributes.frame = newFrame
        
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        [glassmorphismView, deleteButton].forEach {
            $0.isHidden = false
        }
        self.removeGlassBorder()
        self.gestureRecognizers?.removeAll()
        deleteButton.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        glassmorphismView.layer.cornerRadius = 19
        glassmorphismView.clipsToBounds = true
    }

}

extension VerifiedAreasCollectionViewCell {
    
    func bindData(_ title: String, _ indexRow: Int) {
        label.setLabel(text: title, style: .b1R)
        self.setNeedsLayout()
        self.layoutIfNeeded()
        DispatchQueue.main.async {
            self.glassmorphismView.refreshBlurEffect()
        }
    }
    
}

extension VerifiedAreasCollectionViewCell {
    
    func setAddButton() {
        [glassmorphismView, deleteButton].forEach {
            $0.isHidden = true
        }
        label.setLabel(text: StringLiterals.Profile.addVerifiedArea,
                       style: .b1R,
                       color: .labelAction)
        DispatchQueue.main.async {
            self.setNeedsLayout()
            self.layoutIfNeeded()
            self.do {
                $0.addGlassBorder(.init(width: 1, cornerRadius: 19, glassmorphismType: .buttonGlassDefault))
            }
        }
    }
    
}
