//
//  CustomTextFieldView.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/17/25.
//

import UIKit

final class CustomTextFieldView: BaseView {
    
    // MARK: - UI Propeties
    
    private let scrollView = UIScrollView()
    
    private var glassBorderBackgroundView = UIView()
    
    private let textView = UITextView()
    
    private let characterCountLabel = UILabel()
    
    private let maxCharacterLabel = UILabel()
    
    private let placeholderLabel = UILabel()
    
    // MARK: - Properties
    
    var onTextChanged: ((String) -> Void)?
    
    
    // MARK: - LifeCycle

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
            $0.textColor = .acWhite
            $0.font = ACFontType.b1R.fontStyle.font
            $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            $0.delegate = self
            $0.isScrollEnabled = false
        }

        placeholderLabel.setLabel(text: StringLiterals.Withdrawal.withdrawalReason,
                                  style: .b1R,
                                  color: .gray500)
        
        characterCountLabel.setLabel(text: "00", style: .c1R)

        maxCharacterLabel.setLabel(text: "/50",
                                   style: .c1R,
                                   color: .gray500)
    }

    override func setHierarchy() {
        super.setHierarchy()

        addSubview(scrollView)
        scrollView.addSubviews(glassBorderBackgroundView, textView)
        addSubviews(placeholderLabel,
                    characterCountLabel,
                    maxCharacterLabel)
    }


    override func setLayout() {
        super.setLayout()

        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(characterCountLabel.snp.top).offset(-4)
        }
        
        glassBorderBackgroundView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.widthRatio*328)
            $0.height.greaterThanOrEqualTo(60).priority(.required)
        }
        
        textView.snp.makeConstraints {
            $0.edges.equalTo(glassBorderBackgroundView.snp.edges).inset(1)
        }

        placeholderLabel.snp.makeConstraints {
            $0.top.equalTo(textView).inset(10)
            $0.horizontalEdges.equalTo(textView).inset(13)
        }
        
        maxCharacterLabel.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.width.equalTo(19)
        }
        
        characterCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20*ScreenUtils.widthRatio)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(18)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        glassBorderBackgroundView.layoutIfNeeded()
        
        glassBorderBackgroundView.addGlassBorder(GlassBorderAttributes(width: 1, cornerRadius: 8, glassmorphismType: .buttonGlassDefault))
    }

    func updateCharacterCount(_ count: Int) {
        characterCountLabel.text = count < 10 ? "0\(count)" :"\(count)"
    }

    private func scrollToCaret() {
        guard let selectedTextRange = textView.selectedTextRange else { return }

        let caretRect = textView.caretRect(for: selectedTextRange.start)
        let caretRectInScrollView = textView.convert(caretRect, to: scrollView)
           
        var contentOffset = scrollView.contentOffset

        if caretRectInScrollView.maxY > (scrollView.bounds.height + contentOffset.y) {
            contentOffset.y = caretRectInScrollView.maxY - scrollView.bounds.height
            scrollView.setContentOffset(contentOffset, animated: true)

        } else if caretRectInScrollView.minY < contentOffset.y {
             contentOffset.y = caretRectInScrollView.minY
             scrollView.setContentOffset(contentOffset, animated: true)
        }
    }
}


// MARK: - UITextViewDelegate

extension CustomTextFieldView: UITextViewDelegate  {
    
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
    
}
