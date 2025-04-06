//
//  VerifiedAreaDeletableView.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/11/25.
//

import UIKit

class LabelBoxWithDeletableButton: BaseView {
    
    // MARK: - UI Properties
    
    private let stackView = UIStackView()
    
    private let label = UILabel()
    
    private let deleteButton = UIButton()
    
    var verifiedArea: VerifiedAreaModel? = nil
    
    // MARK: - Life Cycles
    
    override func setHierarchy() {
        self.addSubview(stackView)
        
        stackView.addArrangedSubviews(
            label,
            deleteButton
        )
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.verticalEdges.equalToSuperview().inset(10)
        }
        
        deleteButton.snp.makeConstraints {
            $0.size.equalTo(28)
        }
    }
    
    override func setStyle() {
        self.do {
            $0.backgroundColor = .gray8
            $0.layer.borderColor = UIColor.gray6.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 4
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        label.do {
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
        
        deleteButton.do {
            $0.setImage(.icDismissCircleGray, for: .normal)
        }
    }
    
}


// MARK: - Internal Methods

extension LabelBoxWithDeletableButton {
    
    func setLabel(_ text: String) {
        label.setLabel(text: text, style: .s1)
    }
    
    func addDeleteAction(_ target: Any?,
                   action: Selector,
                   for controlEvents: UIControl.Event) {
        deleteButton.addTarget(target, action: action, for: controlEvents)
    }
    
}
