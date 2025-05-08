//
//  SpotListCollectionViewHeader.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/15/25.
//

import UIKit

class SpotListCollectionViewHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier: String = String(describing: SpotListCollectionViewHeader.self)
    
    
    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHierarchy() {
        self.addSubview(titleLabel)
    }
    
    func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    func setStyle() {
        backgroundColor = .clear
        let title = StringLiterals.SpotList.bestChoice
        titleLabel.setLabel(text: title, style: .t2SB)
    }
    
}
