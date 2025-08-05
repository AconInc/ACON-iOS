//
//  WithdrawalViewController.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/16/25.
//

import UIKit

final class WithdrawalViewController: BaseNavViewController {
    
    // MARK: - UI Properties
    
    private let containerView = UIView()
    
    private let reasonTitleLabel = UILabel()
    
    private let reasonDescriptionLabel = UILabel()
    
    private let optionsTableView = WithdrawalTableView()
    
    private let submitButton: ACButton = ACButton(style: GlassButton(glassmorphismType: .buttonGlassDefault, buttonType: .full_12_t4SB), title: StringLiterals.Withdrawal.submit)
    
    private let otherReasonTextFieldView = CustomTextFieldView()
    
    
    // MARK: - Properties
    
    var viewModel = WithdrawalViewModel()

    private var shouldEnableSubmitButton: Bool = false
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBinding()
        setKeyboardHandling()
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setBackButton()
        self.setCenterTitleLabelStyle(title: StringLiterals.Withdrawal.title)
        self.setGlassMorphism()
        
        reasonTitleLabel.setLabel(text: StringLiterals.Withdrawal.reasonTitle,
                                  style: .h4SB)
        
        reasonDescriptionLabel.setLabel(text: StringLiterals.Withdrawal.reasonDescription,
                                        style: .b1R,
                                        color: .gray500)
        
        submitButton.do {
            $0.updateGlassButtonState(state: .disabled)
            $0.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        }
        
        otherReasonTextFieldView.isHidden = true
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.contentView.addSubview(containerView)
        
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
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        reasonTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40*ScreenUtils.heightRatio)
            $0.leading.equalToSuperview().offset(ScreenUtils.horizontalInset)
            $0.width.equalTo(256)
        }
        
        reasonDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(104*ScreenUtils.heightRatio)
            $0.leading.equalTo(reasonTitleLabel)
            $0.width.equalTo(271)
            $0.height.equalTo(60)
        }
        
        optionsTableView.snp.makeConstraints {
            $0.top.equalTo(reasonDescriptionLabel.snp.bottom).offset(40*ScreenUtils.heightRatio)
            $0.leading.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.width.equalTo(262*ScreenUtils.widthRatio)
            $0.height.equalTo(128*ScreenUtils.heightRatio)
        }
        
        otherReasonTextFieldView.snp.makeConstraints{
            $0.top.equalTo(optionsTableView.snp.bottom).offset(12*ScreenUtils.heightRatio)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.height.equalTo(86*ScreenUtils.heightRatio)
        }
        
        submitButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(21+ScreenUtils.heightRatio*16)
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.horizontalInset)
            $0.height.equalTo(54)
        }
    }
    
}


// MARK: - @objc funtions

extension WithdrawalViewController {
    
    @objc func submitButtonTapped() {
        if viewModel.selectedOption.value == StringLiterals.Withdrawal.optionOthers,
           let inputText = viewModel.inputText.value {
            viewModel.selectedOption.value = inputText
        }
        AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.serviceWithdraw, properties: ["exit_reason": self.viewModel.selectedOption.value ?? ""])
        presentWithdrawalSheet()
    }
    
}

extension WithdrawalViewController {
    
    private func presentWithdrawalSheet() {
        let sheetVC = WithdrawalConfirmationViewController()
        sheetVC.viewModel = viewModel
        sheetVC.setSheetLayout(detent: .semiShort)

        DispatchQueue.main.async {
            self.otherReasonTextFieldView.isHidden = (self.viewModel.selectedOption.value != StringLiterals.Withdrawal.optionOthers)
        }
        present(sheetVC, animated: true)
    }
    
    private func setBinding() {
        optionsTableView.viewModel = viewModel
        self.updateButtonState()
        
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
            self.updateButtonState()
        }
        
        viewModel.ectOption.bind { [weak self] _ in
            self?.updateButtonState()
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
    
    func updateButtonState() {
        shouldEnableSubmitButton = viewModel.ectOption.value ?? true
        if shouldEnableSubmitButton {
            submitButton.updateGlassButtonState(state: .default)
        } else {
            submitButton.updateGlassButtonState(state: .disabled)
        }
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
