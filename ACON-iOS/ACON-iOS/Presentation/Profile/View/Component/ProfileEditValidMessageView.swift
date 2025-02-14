//
//  ProfileEditValidMessageView.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import UIKit

class ProfileEditValidMessageView: BaseView {
    
    // MARK: - UI Properties
    
    private let firstIcon = UIImageView()
    
    private let firstLine = UILabel()
    
    private let secondIcon = UIImageView()
    
    private let secondLine = UILabel()
    
    
    // MARK: - Life Cycle
    
    override func setHierarchy() {
        self.addSubviews(
            firstIcon,
            firstLine,
            secondIcon,
            secondLine
        )
    }
    
    override func setLayout() {
        firstIcon.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        firstLine.snp.makeConstraints {
            $0.leading.equalTo(firstIcon.snp.trailing).offset(4)
            $0.centerY.equalTo(firstIcon)
        }
        
        secondIcon.snp.makeConstraints {
            $0.top.equalTo(firstIcon.snp.bottom).offset(4)
            $0.bottom.leading.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        secondLine.snp.makeConstraints {
            $0.leading.equalTo(secondIcon.snp.trailing).offset(4)
            $0.centerY.equalTo(secondIcon)
        }
    }
    
    override func setStyle() {
        hideFirstLine(true)
        hideSecondLine(true)
    }
    
    private func hideFirstLine(_ isHidden: Bool) {
        [firstIcon, firstLine].forEach {
            $0.isHidden = isHidden
        }
    }
    
    private func hideSecondLine(_ isHidden: Bool) {
        [secondIcon, secondLine].forEach {
            $0.isHidden = isHidden
        }
    }
    
    
    // MARK: - Internal Methods
    
    func setValidMessage(_ type: ProfileValidMessageType) {
        let idxErrMsg: String = "⚠️Index out of range"
        
        switch type {
        case .none:
            hideFirstLine(true)
            hideSecondLine(true)
            
        case .nicknameMissing, .nicknameTaken, .invalidDate, .areaMissing:
            guard type.texts.count == 1 else { print(idxErrMsg); return }
            hideFirstLine(false)
            hideSecondLine(true)
            firstIcon.image = .icError20
            firstLine.setLabel(text: type.texts[0], style: .s2, color: .red1)
            
        case .nicknameOK:
            guard type.texts.count == 1 else { print(idxErrMsg); return }
            hideFirstLine(false)
            hideSecondLine(true)
            firstIcon.image = .icLocalCheckMark20
            firstLine.setLabel(text: type.texts[0], style: .s2, color: .blue1)
        
        case .invalidChar:
            guard type.texts.count == 2 else { print(idxErrMsg); return }
            hideFirstLine(false)
            hideSecondLine(false)
            firstIcon.image = .icError20
            firstLine.setLabel(text: type.texts[0], style: .s2, color: .red1)
            secondIcon.image = .icError20
            secondLine.setLabel(text: type.texts[1], style: .s2, color: .red1)
        }
    }
    
}
