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
    private var titleLabel = UILabel()
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        
        withdrawalImageView.do {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tapGesture)
            $0.image = .icRadio
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
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
        titleLabel.setLabel(text: name,
                            style: .s1,
                            alignment: .center,
                            numberOfLines: 0)
        if isSelected {
            withdrawalImageView.image = .icRadioPressed
        } else {
            withdrawalImageView.image = .icRadio
        }
    }
    
    @objc private func imageTapped() {
        guard let tableView = superview as? UITableView else { return }
        guard let indexPath = tableView.indexPath(for: self) else { return }
        
        (tableView as? WithdrawalTableView)?.handleSelection(at: indexPath)
    }
    
}
