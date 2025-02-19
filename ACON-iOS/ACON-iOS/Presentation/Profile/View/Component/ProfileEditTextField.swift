//
//  ProfileEditTextField.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/9/25.
//

import UIKit

import Lottie

class ProfileEditTextField: UITextField {
    
    // MARK: - Internal Property
    
    var observableText: ObservablePattern<String> = ObservablePattern(nil)
    
    
    // MARK: - UI Settings
    
    private let horizontalInset: CGFloat = 12
    
    private let clearButtonSize: CGFloat = 28
    
    private let clearButtonSpacing: CGFloat = 16
    
    private let rightItemView = UIView()
    
    private let clearButton = UIButton()
    
    private let loadingRightView = UIView()
    
    private let animationView = LottieAnimationView(name: "loadingWhite")
    
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setHierarchy()
        setLayout()
        setStyle()
        addTarget()
        addDoneButtonToKeyboard()
        observeText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setHierarchy() {
        loadingRightView.addSubview(animationView)
    }
    
    private func setLayout() {
        animationView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview().offset(clearButtonSpacing)
            $0.trailing.equalToSuperview().offset(-horizontalInset)
            $0.size.equalTo(28)
        }
    }
    
    private func setStyle() {
        setTextFieldStyle()
        
        setKeyboardStyle()
        
        animationView.do {
            $0.isHidden = true
        }
        
        clearButton.do {
            var config = UIButton.Configuration.plain()
            config.image = .icDissmissCircleGray
            config.contentInsets = .init(
                top: 0,
                leading: clearButtonSpacing,
                bottom: 0,
                trailing: horizontalInset
            )
            $0.configuration = config
        }
    }
    
    private func addTarget() {
        clearButton.addTarget(
            self,
            action: #selector(tappedClearButton),
            for: .touchUpInside
        )
    }
    
    private func addDoneButtonToKeyboard() {
        let toolbar = UIToolbar()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(dismissKeyboard))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.frame = .init(x: 0, y: 0, width: ScreenUtils.width, height: 44)
        toolbar.items = [flexSpace, doneButton]
        
        self.inputAccessoryView = toolbar
    }
    
    private func observeText() {
        self.addTarget(
            self,
            action: #selector(setObservableText),
            for: .editingChanged
        )
    }
    
}


// MARK: - UI Setting Methods

private extension ProfileEditTextField {
    
    func setTextFieldStyle() {
        self.do {
            $0.backgroundColor = .gray9
            $0.defaultTextAttributes = [
                .font: ACFontStyleType.s1.font,
                .kern: ACFontStyleType.s1.kerning,
                .foregroundColor: UIColor.acWhite
            ]
            $0.layer.borderColor = UIColor.gray6.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 4
        }
    }
    
    func setKeyboardStyle() {
        self.do {
            $0.autocorrectionType = .no
            
            $0.rightView?.frame = CGRect(
                x: 0,
                y: 0,
                width: clearButtonSize + clearButtonSpacing + horizontalInset,
                height: clearButtonSize
            )
            $0.rightView = clearButton
            $0.rightViewMode = .always
            
            $0.leftView = UIView(frame: CGRect(
                x: 0,
                y: 0,
                width: horizontalInset,
                height: self.frame.height
            ))
            $0.leftViewMode = .always
        }
    }
    
}


// MARK: - @objc function

private extension ProfileEditTextField {
    
    @objc
    func tappedClearButton() {
        self.text = ""
        self.observableText.value = ""
    }
    
    @objc func dismissKeyboard() {
        self.resignFirstResponder()
    }
    
    @objc
    func applyDateFormat() {
        let rawText = self.text?.replacingOccurrences(of: ".", with: "") ?? ""
        self.text = dateFormat(rawText)
    }
    
    @objc
    func setObservableText() {
        self.observableText.value = self.text
    }
    
}


// MARK: - Helpers

private extension ProfileEditTextField {
    
    func dateFormat(_ text: String) -> String {
        var formattedText = ""
        
        for (index, char) in text.enumerated() {
            if index == 4 || index == 6 { // 4번째, 6번째 문자 뒤에 '.' 삽입
                formattedText.append(".")
            }
            formattedText.append(char)
        }
        
        return formattedText
    }
    
}


// MARK: - Internal Methods

extension ProfileEditTextField {
    
    func setPlaceholder(as placeholder: String) {
        self.attributedPlaceholder = placeholder.ACStyle(.s1, .gray5)
    }
    
    func setDateStyle() {
        self.addTarget(
            self,
            action: #selector(applyDateFormat),
            for: .editingChanged
        )
    }
    
    func changeBorderColor(toRed: Bool) {
        self.layer.borderColor = toRed ? UIColor.red1.cgColor : UIColor.gray6.cgColor
    }
    
    func hideClearButton(isHidden: Bool) {
        clearButton.isHidden = isHidden
    }
    
    func startCheckingAnimation() {
        self.rightView = loadingRightView
        animationView.isHidden = false
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func endCheckingAnimation() {
        self.rightView = clearButton
        animationView.isHidden = true
        animationView.loopMode = .playOnce
        
        animationView.play(completion: { (isFinished) in
            if isFinished {
                self.animationView.stop()
            }
        })
    }
}
