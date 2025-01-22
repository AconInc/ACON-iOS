//
//  SpotListCollectionViewFooter.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/22/25.
//

import UIKit

class SpotListCollectionViewFooter: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier: String = String(describing: SpotListCollectionViewFooter.self)
    
    
    // MARK: - UI Properties
    
    private let footerLabel = UILabel()
    
    
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
        self.addSubview(footerLabel)
    }
    
    func setLayout() {
        footerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(44)
        }
    }
    
    func setStyle() {
        backgroundColor = .clear
        let text = StringLiterals.SpotList.footerText
        footerLabel.setLabel(
            text: text,
            style: .b4,
            color: .gray5,
            alignment: .center
        )
    }
    
}
