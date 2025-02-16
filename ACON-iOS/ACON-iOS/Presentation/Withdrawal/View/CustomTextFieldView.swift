//
//  CustomTextFieldView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/17/25.
//
import UIKit

import SnapKit
import Then

final class CustomTextFieldView: BaseView, UITextViewDelegate {

    private let textView = UITextView()
    private let characterCountLabel = UILabel()
    private let placeholderLabel = UILabel()

    var onTextChanged: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        textView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setStyle() {
        super.setStyle()

        textView.do {
            $0.backgroundColor = .clear
            $0.textColor = .gray5
            $0.font = .systemFont(ofSize: 16)
            $0.layer.borderColor = UIColor.gray6.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 4.0
            $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            $0.delegate = self
        }
        
        placeholderLabel.do {
            $0.text = "탈퇴하려는 이유를 적어주세요"
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .lightGray
            $0.isHidden = false
        }

        characterCountLabel.do {
            $0.text = "0 / 50"
            $0.font = .systemFont(ofSize: 12)
            $0.textColor = .gray
            $0.textAlignment = .right
        }
    }

    override func setHierarchy() {
        super.setHierarchy()
        addSubviews(textView,placeholderLabel,characterCountLabel)
    }

    override func setLayout() {
        super.setLayout()
        
        textView.snp.removeConstraints()

        textView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(100).priority(.required)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalTo(textView).offset(10)
            $0.leading.equalTo(textView).offset(15)
            $0.trailing.equalTo(textView).offset(-10)
        }
        
        characterCountLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(4)
            $0.trailing.equalTo(textView.snp.trailing)
            $0.bottom.equalToSuperview()
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty

        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
      
        if estimatedSize.height > 100 {
              textView.snp.updateConstraints {
                  $0.height.equalTo(estimatedSize.height)
              }
          }
      

        onTextChanged?(textView.text)
        updateCharacterCount(textView.text.count)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         let currentText = textView.text ?? ""
         guard let stringRange = Range(range, in: currentText) else { return false }
         
         let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
         
         return updatedText.count <= 50
     }

    func updateCharacterCount(_ count: Int) {
        characterCountLabel.text = "\(count) / 50"
    }
}
