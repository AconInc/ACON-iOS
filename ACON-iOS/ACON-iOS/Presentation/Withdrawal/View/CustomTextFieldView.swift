//
//  CustomTextFieldView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/17/25.
//
import UIKit
import SnapKit
import Then

final class CustomTextFieldView: BaseView, UITextFieldDelegate {
    
    let textField = UITextField()
    var characterCountLabel = UILabel()
    
    var onTextChanged: ((String) -> Void)? {
        didSet {
            onTextChanged?(textField.text ?? "")
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        super.setStyle()
        
        textField.do {
            $0.placeholder = "탈퇴하려는 이유를 적어주세요"
            $0.borderStyle = .roundedRect
            $0.backgroundColor = .clear
            $0.textColor = .white
        }
        
        characterCountLabel.do {
            $0.text = "00 / 50"
            $0.font = .systemFont(ofSize: 12)
            $0.textColor = .gray
            $0.textAlignment = .right
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        addSubview(textField)
        addSubview(characterCountLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        textField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        characterCountLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(4)
            $0.trailing.equalTo(textField.snp.trailing)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        if newText.count <= 50 {
            onTextChanged?(newText)
            characterCountLabel.text = "\(newText.count) / 50"
            return true
        }
        return false
    }
    
    func updateCharacterCount(_ count: Int) {
        characterCountLabel.text = "\(count) / 50"
    }
}
