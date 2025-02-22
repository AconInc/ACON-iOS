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

    private let scrollView = UIScrollView()
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

        scrollView.do {
            $0.showsVerticalScrollIndicator = true
            $0.alwaysBounceVertical = true
        }
        
        textView.do {
            $0.backgroundColor = .clear
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 16)
            $0.layer.borderColor = UIColor.gray6.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 4.0
            $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            $0.delegate = self
            $0.isScrollEnabled = false
        }

        placeholderLabel.do {
            $0.text = StringLiterals.Withdrawal.withdrawalReason
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

        addSubview(scrollView)
        scrollView.addSubview(textView)
        addSubviews(placeholderLabel, characterCountLabel)
    }


    override func setLayout() {
        super.setLayout()

        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(characterCountLabel.snp.top).offset(-4)
        }
        
        textView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(self)
            $0.width.equalTo(self)
            $0.height.greaterThanOrEqualTo(100).priority(.required)
        }


        placeholderLabel.snp.makeConstraints {
            $0.top.equalTo(textView).offset(10)
            $0.leading.equalTo(textView).offset(15)
            $0.trailing.equalTo(textView).offset(-10)
        }

        characterCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(textView.snp.trailing)
            $0.bottom.equalToSuperview()
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty

        onTextChanged?(textView.text)
        updateCharacterCount(textView.text.count)
        scrollToCaret()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
         scrollToCaret()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
                return false
            }
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        return updatedText.count <= 50
    }

    func updateCharacterCount(_ count: Int) {
        characterCountLabel.text = "\(count) / 50"
    }

    private func scrollToCaret() {
        guard let selectedTextRange = textView.selectedTextRange else { return }

        let caretRect = textView.caretRect(for: selectedTextRange.start)
        let caretRectInScrollView = textView.convert(caretRect, to: scrollView)
           
        var contentOffset = scrollView.contentOffset
        let textViewHeight = textView.bounds.height

        if caretRectInScrollView.maxY > (scrollView.bounds.height + contentOffset.y) {
            contentOffset.y = caretRectInScrollView.maxY - scrollView.bounds.height
            scrollView.setContentOffset(contentOffset, animated: true)

        } else if caretRectInScrollView.minY < contentOffset.y {
             contentOffset.y = caretRectInScrollView.minY
             scrollView.setContentOffset(contentOffset, animated: true)
        }
    }
}
