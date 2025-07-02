//
//  WithdrawalTableViewCell.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/17/25.
//

import UIKit


final class WithdrawalTableViewCell: BaseTableViewCell {
    
    // MARK: - UI Properties
    
    private let selectButton = UIButton()
    
    private var titleLabel = UILabel()
    
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        /// 트슛 - 버튼 터치를 셀이 잡아먹음
        self.isUserInteractionEnabled = true
        self.contentView.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        super.setStyle()
        
        selectButton.do {
            $0.isUserInteractionEnabled = true
            $0.setImage(.icRadio, for: .normal)
            $0.setImage(.icRadioSelected, for: .selected)
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubviews(selectButton, titleLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        selectButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(selectButton.snp.trailing).offset(8)
            $0.centerY.equalTo(selectButton)
        }
    }
    
    func checkConfigure(name: String, isSelected: Bool) {
        titleLabel.setLabel(text: name, style: .t5R)
        selectButton.isSelected = isSelected
    }
    
    func selectButtonTapped() {
        selectButton.isSelected.toggle()
    }
    
}
