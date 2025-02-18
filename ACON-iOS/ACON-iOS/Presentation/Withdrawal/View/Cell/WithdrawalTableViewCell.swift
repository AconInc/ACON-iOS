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
        selectionStyle = .none

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
            $0.image = UIImage(named: "circle")
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
        }
        
        withdrawalImageView.snp.makeConstraints {
            $0.leading.equalTo(container.snp.leading)
            $0.top.equalTo(container.snp.top)
            $0.height.equalTo(22)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(withdrawalImageView.snp.trailing).offset(8)
            $0.centerY.equalTo(withdrawalImageView)
        }
    }
    
    func checkConfigure(name: String, isSelected: Bool) {
        titleLabel.text = name
        if isSelected {
            withdrawalImageView.image = UIImage(named: "fillCircle")
        } else {
            withdrawalImageView.image = UIImage(named: "circle")
        }
    }
    
}
