//
//  WithdrawalViewController.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/16/25.
//

import UIKit

import SnapKit
import Then

final class WithdrawalViewController: BaseNavViewController {
    
    private let viewModel = WithdrawalViewModel()
    private let otherReasonTextFieldView = CustomTextFieldView()
    //    private let glassmorphismView = GlassmorphismView()
    
    private let reasonTitleLabel = UILabel()
    private let reasonDescriptionLabel = UILabel()
    private let optionsTableView = WithdrawalTableView()
    private let submitButton = UIButton()
    private let containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinding()
    }
    
    override func setStyle() {
        super.setStyle()
        
        view.backgroundColor = .gray9
        
        setBackgroundColor(color: .gray9)
        
        setBackButton()
        
        setCenterTitleLabelStyle(title: "서비스 탈퇴")
        
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
        
        navigationBarView.addSubviews(leftButton, titleLabel)
        
        view.addSubview(containerView)
        
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
        
        leftButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(leftButton)
            $0.centerX.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
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
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(200)
        }
        
        otherReasonTextFieldView.snp.makeConstraints{
            $0.top.equalTo(optionsTableView.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(120)
        }
        
        submitButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
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
            sheet.detents = [SheetUtils().acShortDetent]
            sheet.prefersGrabberVisible = true
        }
        present(sheetVC, animated: true)
    }
    
    func didSelectOtherOption(isSelected: Bool) {
        otherReasonTextFieldView.isHidden = !isSelected
    }
    
    private func setBinding() {
        optionsTableView.viewModel = viewModel
        self.buttonState()
        
        viewModel.selectedOption.bind { [weak self] selectedOption in
            guard let self = self else { return }
            
            let isOtherSelected = selectedOption == StringLiterals.Withdrawal.optionOthers
            otherReasonTextFieldView.isHidden = !isOtherSelected
        }
        
        viewModel.inputText.bind { [weak self] _ in
            guard let self = self else { return }
            self.buttonState()
        }
        
        otherReasonTextFieldView.onTextChanged = { [weak self] text in
            self?.viewModel.updateInputText(text)
        }
        
        viewModel.shouldDismissKeyboard.bind { [weak self] shouldDismiss in
            guard let shouldDismiss = shouldDismiss else { return }
            
            if shouldDismiss {
                self?.view.endEditing(true)
                self?.viewModel.shouldDismissKeyboard.value = false
            }
        }
    }
    
    private func buttonState() {
        let isOptionSelected = viewModel.selectedOption.value != nil
        let isInputTextValid = !(viewModel.inputText.value?.isEmpty ?? true)
        
        let shouldEnableSubmitButton = isOptionSelected &&
        (viewModel.selectedOption.value != StringLiterals.Withdrawal.optionOthers || isInputTextValid)
        
        submitButton.isEnabled = shouldEnableSubmitButton
        submitButton.backgroundColor = shouldEnableSubmitButton ? .gray6 : .gray7
        
        let textColor = shouldEnableSubmitButton ? UIColor.acWhite : UIColor.gray5
        
        submitButton.setTitleColor(textColor, for: .normal)
    }
    
}

// MARK: up key mode
extension WithdrawalViewController{
    
    
}

// MARK: about navigationbar
extension WithdrawalViewController{
    
    @objc
    override func backButtonTapped() {
        // TODO: i will fix
        let mainVC = SplashViewController()
        
        if let navigationController = navigationController {
            navigationController.pushViewController(mainVC, animated: true)
        } else {
            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: true)
        }
    }
    
}
