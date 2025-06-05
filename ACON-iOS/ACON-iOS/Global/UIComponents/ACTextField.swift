//
//  ACTextField.swift
//  ACON-iOS
//
//  Created by 김유림 on 4/6/25.
//

import UIKit

import Lottie

final class ACTextField: UIView {
    
    // MARK: - Internal Property

    var observableText: ObservablePattern<String> = ObservablePattern(nil)

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    var delegate: UITextFieldDelegate? {
        get { textField.delegate }
        set { textField.delegate = newValue }
    }


    // MARK: - UI Property

    private let horizontalInset: CGFloat = 12

    private let horizontalSpacing: CGFloat = 8

    private let iconSize: CGFloat = 28

    private var icon: UIImage?

    private var bgColor: UIColor?

    private var borderColor: UIColor?

    private var borderWidth: CGFloat?

    private var cornerRadius: CGFloat

    private var fontStyle: ACFontType

    private let iconImageView = UIImageView()

    let textField = UITextField()

    private let clearButton = UIButton()

    private let animationView = LottieAnimationView(name: "loadingWhite")

    private var glassmorphismView: GlassmorphismView?

    private var glassBorderAttribute: GlassBorderAttributes?


    // MARK: - Initializer

    /// 일반 ACTextField
    init(
        icon: UIImage? = nil,
        backgroundColor: UIColor = .gray800,
        borderColor: UIColor = .gray600,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = 4,
        fontStyle: ACFontType = .t4R,
        doneButton: Bool = true
    ) {
        self.icon = icon
        self.bgColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.fontStyle = fontStyle
        
        super.init(frame: .zero)
        
        setHierarchy()
        setLayout()
        setStyle()
        addTarget()
        if doneButton { addDoneButtonToKeyboard() }
    }

    /// Glassmorphism이 적용된 ACTextField
    init(
        icon: UIImage? = nil,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = 4,
        fontStyle: ACFontType = .t4R,
        doneButton: Bool = true,
        backgroundGlassType: GlassmorphismType? = nil,
        borderGlassType: GlassmorphismType? = nil
    ) {
        self.icon = icon
        self.cornerRadius = cornerRadius
        self.fontStyle = fontStyle

        super.init(frame: .zero)

        setHierarchy()
        setLayout()
        setStyle()
        addTarget()
        if doneButton { addDoneButtonToKeyboard() }

        if let backgroundGlassType = backgroundGlassType {
            setGlassmorphism(backgroundGlassType)
        }

        if let borderGlassType = borderGlassType {
            self.glassBorderAttribute = GlassBorderAttributes(
                width: borderWidth,
                cornerRadius: cornerRadius,
                glassmorphismType: borderGlassType
            )
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let glassBorderAttribute = glassBorderAttribute {
            self.addGlassBorder(glassBorderAttribute)
        }
    }


    // MARK: - Private Methods

    private func setHierarchy() {
        if icon != nil {
            self.addSubview(iconImageView)
        }
        self.addSubviews(textField, clearButton, animationView)
    }

    private func setLayout() {
        if icon != nil {
            iconImageView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(horizontalInset)
                $0.centerY.equalToSuperview()
                $0.size.equalTo(iconSize)
            }
        }

        textField.snp.makeConstraints {
            let leadingAnchor = icon == nil ? self.snp.leading : iconImageView.snp.trailing
            let leadingOffset = icon == nil ? horizontalInset : horizontalSpacing
            
            $0.leading.equalTo(leadingAnchor).offset(leadingOffset)
            $0.trailing.equalTo(clearButton.snp.leading).offset(-horizontalSpacing)
            $0.centerY.equalToSuperview()
        }

        clearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-horizontalInset)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(iconSize)
        }

        animationView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-horizontalInset)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(iconSize)
        }
    }

    private func setStyle() {
        self.do {
            $0.backgroundColor = bgColor
            $0.clipsToBounds = true
            $0.layer.borderColor = borderColor?.cgColor
            $0.layer.borderWidth = borderWidth ?? 0.0
            $0.layer.cornerRadius = cornerRadius
        }

        textField.do {
            $0.autocorrectionType = .no
            $0.defaultTextAttributes = [
                .font: fontStyle.fontStyle.font,
                .kern: fontStyle.kerning(isKorean: false),
                .foregroundColor: UIColor.acWhite
            ]
        }

        animationView.do {
            $0.isHidden = true
        }
        
        clearButton.do {
            $0.setImage(.icClear, for: .normal)
        }

        if icon != nil {
            iconImageView.do {
                $0.image = icon
                $0.contentMode = .scaleAspectFit
            }
        }
    }

    private func addTarget() {
        clearButton.addTarget(
            self,
            action: #selector(tappedClearButton),
            for: .touchUpInside
        )

        textField.addTarget(
            self,
            action: #selector(updateObservableText),
            for: .editingChanged
        )
    }

    private func addDoneButtonToKeyboard() {
        let toolbar = UIToolbar()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(dismissKeyboard))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.frame = .init(x: 0, y: 0, width: ScreenUtils.width, height: 44)
        toolbar.items = [flexSpace, doneButton]
        
        textField.inputAccessoryView = toolbar
    }

}


// MARK: - @objc function

private extension ACTextField {

    @objc
    func tappedClearButton() {
        self.text = ""
        self.observableText.value = ""
    }

    @objc
    func dismissKeyboard() {
        textField.resignFirstResponder()
    }

    @objc
    func updateObservableText() {
        self.observableText.value = self.text
    }

    @objc
    func formatAsDate() {
        let rawText = self.text?.replacingOccurrences(of: ".", with: "") ?? ""
        var formattedText = ""
        for (index, char) in rawText.enumerated() {
            if index == 4 || index == 6 { // 4번째, 6번째 문자 뒤에 '.' 삽입
                formattedText.append(".")
            }
            formattedText.append(char)
        }
        self.text = formattedText
    }

}


// MARK: - Internal Methods

extension ACTextField {

    func setPlaceholder(as placeholder: String) {
        textField.attributedPlaceholder = placeholder.attributedString(fontStyle, .gray500)
    }

    func setAsDateField() {
        textField.addTarget(
            self,
            action: #selector(formatAsDate),
            for: .editingChanged
        )
    }

    func changeBorderColor(to color: UIColor) {
        self.layer.borderColor = color.cgColor
    }

    func hideClearButton(isHidden: Bool) {
        clearButton.isHidden = isHidden
    }

    func startCheckingAnimation() {
        clearButton.isHidden = true
        animationView.isHidden = false
        animationView.loopMode = .loop
        animationView.play()
    }

    func endCheckingAnimation() {
        clearButton.isHidden = false
        animationView.isHidden = true
        animationView.loopMode = .playOnce
        
        animationView.play(completion: { (isFinished) in
            if isFinished {
                self.animationView.stop()
            }
        })
    }

    func setGlassmorphism(_ glassmorphismType: GlassmorphismType) {
        self.backgroundColor = .clear
        
        glassmorphismView = GlassmorphismView(glassmorphismType).then {
            self.insertSubview($0, at: 0)
            $0.isUserInteractionEnabled = false
        }

        glassmorphismView?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
