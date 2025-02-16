//
//  WithdrawalTableViewCell.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/17/25.
//

import UIKit

import SnapKit
import Then

final class WithdrawalTableViewCell: BaseTableViewCell {
    
    private let withdrawalImageView = UIImageView()
    private let titleLabel = UILabel()
    private let container = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        super.setStyle()
        
        withdrawalImageView.do {
            $0.image = UIImage(named: "defaultImage")
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        
        titleLabel.do {
            $0.font = ACFont.s1.font
            $0.textColor = .acWhite
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        contentView.addSubview(container)
        container.addSubviews(withdrawalImageView,titleLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(154).priority(.low)
        }
        
        withdrawalImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(container.snp.width).multipliedBy(1.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(withdrawalImageView.snp.bottom).offset(2)
            $0.centerX.equalTo(container)
            $0.height.equalTo(35).priority(.low)
        }
    }
    
    func checkConfigure(name: String, isSelected: Bool) {
        titleLabel.text = name
        if isSelected {
            withdrawalImageView.image = UIImage(named: "selectedImage") // 선택되었을 때의 이미지
        } else {
            withdrawalImageView.image = UIImage(named: "defaultImage") // 기본 이미지
        }
    }
}
