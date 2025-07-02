//
//  LocalVerificationEditView.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/17/25.
//

import UIKit

class VerifiedAreasEditView: BaseView {
    
    // MARK: - Sizes
    
    private let verticalSpacing: CGFloat = 12
    
    
    // MARK: - UI Properties
    
    private let verifiedAreaTitleLabel = UILabel()
    
    private let verifiedAreaDescriptionLabel = UILabel()

    lazy var verifiedAreaCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: verifiedAreaCollectionViewFlowLayout)
    
    private let verifiedAreaCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.do {
            $0.minimumInteritemSpacing = 8
            $0.minimumLineSpacing = 8
            $0.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            $0.estimatedItemSize = CGSize(width: 88, height: 38)
        }
        return layout
    }()
    
    
    // MARK: - Lifecycle
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(verifiedAreaTitleLabel,
                         verifiedAreaDescriptionLabel,
                         verifiedAreaCollectionView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        verifiedAreaTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtils.heightRatio*40)
            $0.leading.equalToSuperview().offset(ScreenUtils.horizontalInset)
        }
        
        verifiedAreaDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtils.heightRatio*72)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.horizontalInset)
        }
        
        verifiedAreaCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(ScreenUtils.heightRatio*128)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(176)
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        verifiedAreaTitleLabel.setLabel(text: StringLiterals.Profile.verifiedArea + StringLiterals.Profile.neccessaryStarWithSpace, style: .t4SB)
        
        verifiedAreaDescriptionLabel.setLabel(text: StringLiterals.Profile.verifiedAreaDescription,
                                              style: .b1R,
                                              color: .gray500)
        
        verifiedAreaCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
        }
    }
    
}
