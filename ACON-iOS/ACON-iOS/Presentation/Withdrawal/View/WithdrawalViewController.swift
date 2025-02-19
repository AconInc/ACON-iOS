//
//  WithdrawalViewController.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/16/25.
//

import UIKit

import SnapKit
import Then

final class WithdrawalViewController: BaseViewController {
    
    var viewModel = WithdrawalViewModel()
    private let otherReasonTextFieldView = CustomTextFieldView()
    private let glassMorphismView = GlassmorphismView()
    private let topInsetView = UIView()
    
    private let leftButton: UIButton = UIButton()
    private let centerTitleLabel = UILabel()
    
    private let reasonTitleLabel = UILabel()
    private let reasonDescriptionLabel = UILabel()
    private let optionsTableView = WithdrawalTableView()
    private let submitButton = UIButton()
    private let containerView = UIView()
    
    private var shouldEnableSubmitButton: Bool = false
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBinding()
        setKeyboardHandling()
        
    }
    
    override func setStyle() {
        super.setStyle()
        
        view.backgroundColor = .gray9
        
        setBackButton()
        
        setCenterTitleLabelStyle(title: "서비스 탈퇴")
        
        topInsetView.backgroundColor = .clear
        
        glassMorphismView.alpha = 0
        
        reasonTitleLabel.do {
            $0.setLabel(text: StringLiterals.Withdrawal.reasonTitle, style: .h5, color: .acWhite, alignment: .left, numberOfLines: 0)
        }
        
        reasonDescriptionLabel.do {
            $0.setLabel(text: StringLiterals.Withdrawal.reasonDescription, style: .s2, color: .gray5, alignment: .left, numberOfLines: 2)
        }
        
        submitButton.do {
            $0.backgroundColor = .gray7
            $0.layer.cornerRadius = 8
            $0.isEnabled = false
            $0.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
            $0.setTitle("제출하기", for: .normal)
            $0.titleLabel?.font = ACFontStyleType.h7.font
            $0.setTitleColor(.gray5, for: .normal)
        }
        
        otherReasonTextFieldView.isHidden = true
        
        
        func backButtonTapped() {
            if let navigationController = navigationController {
                navigationController.popViewController(animated: true)
            } else {
                dismiss(animated: true)
            }
        }
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        view.addSubviews(containerView,
                         topInsetView,
                         glassMorphismView,
                         leftButton,
                         centerTitleLabel
        )
        
        containerView.addSubviews(
            reasonTitleLabel,
            reasonDescriptionLabel,
            optionsTableView,
            otherReasonTextFieldView,
            submitButton
        )
    }
    
    override func setLayout() {
        super.setLayout()
        
        topInsetView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        glassMorphismView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(ScreenUtils.heightRatio * 56)
        }
        
        leftButton.snp.makeConstraints {
            $0.centerY.equalTo(glassMorphismView.snp.bottom).offset(-ScreenUtils.heightRatio*28)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(24)
        }
        
        centerTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(glassMorphismView)
            $0.centerY.equalTo(leftButton)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(glassMorphismView.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        reasonTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        reasonDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(reasonTitleLabel.snp.bottom).offset(16)
            $0.leading.equalTo(reasonTitleLabel)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        optionsTableView.snp.makeConstraints {
            $0.top.equalTo(reasonDescriptionLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(180)
        }
        
        otherReasonTextFieldView.snp.makeConstraints{
            $0.top.equalTo(optionsTableView.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(120)
        }
        
        submitButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(containerView.snp.bottom).offset(-40)
            $0.height.equalTo(52)
        }
    }
    
}

extension WithdrawalViewController {
    
    @objc func submitButtonTapped() {
        if viewModel.selectedOption.value == StringLiterals.Withdrawal.optionOthers,
           let inputText = viewModel.inputText.value {
            viewModel.selectedOption.value = inputText
        }
        presentWithdrawalSheet()
    }
    
    private func presentWithdrawalSheet() {
        let sheetVC = WithdrawalConfirmationViewController()
        
        if let sheet = sheetVC.sheetPresentationController {
            sheetVC.viewModel = viewModel
            sheet.detents = [ACSheetDetent.shortDetent]
            sheet.prefersGrabberVisible = true
        }
        
        DispatchQueue.main.async {
            self.otherReasonTextFieldView.isHidden = (self.viewModel.selectedOption.value != StringLiterals.Withdrawal.optionOthers)
        }
        present(sheetVC, animated: true)
    }
    
    private func setBinding() {
        optionsTableView.viewModel = viewModel
        self.buttonState()
        
        viewModel.selectedOption.bind { [weak self] selectedOption in
            guard let self = self else { return }
            
            let isOtherSelected = selectedOption == StringLiterals.Withdrawal.optionOthers
            
            if isOtherSelected {
                if let inputText = viewModel.inputText.value, !inputText.isEmpty {
                    viewModel.selectedOption.value = inputText
                }
            }
            
            DispatchQueue.main.async {
                self.otherReasonTextFieldView.isHidden = !isOtherSelected
            }
        }
        
        viewModel.inputText.bind { [weak self] text in
            guard let self = self else { return }
            self.buttonState()
        }
        
        viewModel.ectOption.bind { [weak self] _ in
            self?.buttonState()
        }
        
        otherReasonTextFieldView.onTextChanged = { [weak self] text in
            self?.viewModel.updateInputText(text)
        }
        
        viewModel.shouldDismissKeyboard.bind { [weak self] shouldDismiss in
            guard let shouldDismiss = shouldDismiss, shouldDismiss else { return }
            self?.view.endEditing(true)
            self?.viewModel.shouldDismissKeyboard.value = false
        }
    }
    
    func buttonState() {
        shouldEnableSubmitButton = viewModel.ectOption.value ?? true
        submitButton.isEnabled = shouldEnableSubmitButton
        submitButton.backgroundColor = shouldEnableSubmitButton ? .gray6 : .gray7
        
        let textColor = shouldEnableSubmitButton ? UIColor.acWhite : UIColor.gray5
        
        submitButton.setTitleColor(textColor, for: .normal)
    }
    
}

// MARK: - Keyboard Handling
extension WithdrawalViewController {
    
    func setKeyboardHandling() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        let textViewBottom = otherReasonTextFieldView.convert(otherReasonTextFieldView.bounds, to: view).maxY
        let visibleArea = view.frame.height - keyboardHeight
        
        if textViewBottom > visibleArea {
            let offset = textViewBottom - visibleArea + 20
            
            UIView.animate(withDuration: 0.3) {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: -offset)
            }
            glassMorphismView.alpha = 1
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.containerView.transform = .identity
        }
        glassMorphismView.alpha = 0
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: about navigationbar
extension WithdrawalViewController{
    
    @objc func backButtonTapped() {
        
        let mainVC = ProfileSettingViewController()
        
        if let navigationController = navigationController {
            navigationController.pushViewController(mainVC, animated: true)
        } else {
            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: true)
        }
    }
    
    func setCenterTitleLabelStyle(title: String,
                                  fontStyle: ACFontStyleType = .t2,
                                  color: UIColor = .acWhite,
                                  alignment: NSTextAlignment = .center) {
        centerTitleLabel.do {
            $0.isHidden = false
            $0.setLabel(text: title,
                        style: fontStyle,
                        color: color)
            $0.textAlignment = alignment
        }
    }
    
    func setBackButton() {
        setButtonStyle(button: leftButton, image: .leftArrow)
        setButtonAction(button: leftButton, target: self, action: #selector(backButtonTapped))
    }
    
    func setButtonStyle(button: UIButton, image: UIImage?) {
        button.do {
            $0.isHidden = false
            $0.setImage(image, for: .normal)
        }
    }
    
    func setButtonAction(button: UIButton, target: Any, action: Selector) {
        button.addTarget(target, action: action, for: .touchUpInside)
    }
    
}
