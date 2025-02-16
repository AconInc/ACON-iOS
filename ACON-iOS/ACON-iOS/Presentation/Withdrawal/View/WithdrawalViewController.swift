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
    
    private let viewModel = WithdrawalViewModel()
    private let otherReasonTextFieldView = CustomTextFieldView()
    
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let reasonTitleLabel = UILabel()
    private let reasonDescriptionLabel = UILabel()
    private let optionsTableView = WithdrawalTableView()
    private let submitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinding()
    }
    
    override func setStyle() {
        super.setStyle()
        
        view.backgroundColor = .gray9
        
        backButton.do {
            $0.setImage(UIImage(named: "leftArrow"), for: .normal)
            $0.tintColor = .white
        }
        
        titleLabel.do {
            $0.setLabel(text: StringLiterals.Withdrawal.title, style: .h5, color: .acWhite, alignment: .center, numberOfLines: 0)
        }
        
        reasonTitleLabel.do {
            $0.setLabel(text: StringLiterals.Withdrawal.reasonTitle, style: .h5, color: .acWhite, alignment: .left, numberOfLines: 0)
        }
        
        reasonDescriptionLabel.do {
            $0.setLabel(text: StringLiterals.Withdrawal.reasonDescription, style: .s2, color: .gray5, alignment: .left, numberOfLines: 2)
        }
        
        submitButton.do {
            $0.backgroundColor = .gray8
            $0.layer.cornerRadius = 8
            $0.isEnabled = false
            $0.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
            $0.setAttributedTitle(text: "제출",
                                  style: ACFont.h8,
                                  color: .gray6,
                                  for: .normal)
        }
        
        otherReasonTextFieldView.isHidden = true
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        view.addSubviews(backButton,
                         titleLabel,
                         reasonTitleLabel,
                         reasonDescriptionLabel,
                         optionsTableView,
                         otherReasonTextFieldView,
                         submitButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
        }
        
        reasonTitleLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(40)
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
            $0.height.equalTo(56 * 4)
        }
        
        otherReasonTextFieldView.snp.makeConstraints{
            $0.top.equalTo(optionsTableView.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(120)
        }
        
        submitButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(52)
        }
    }
}

extension WithdrawalViewController {
    
    @objc func submitButtonTapped() {
        print("go to popup")
    }
    
    func didSelectOtherOption(isSelected: Bool) {
        otherReasonTextFieldView.isHidden = !isSelected
    }
    
    private func setBinding() {
        otherReasonTextFieldView.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.inputText.value = text
        }
        
        viewModel.inputText.bind { [weak self] text in
            guard let self = self else { return }
            self.otherReasonTextFieldView.updateCharacterCount(text?.count ?? 0)
        }
    }
}


import SwiftUI

struct WithdrawalViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let viewController = WithdrawalViewController()
        return UINavigationController(rootViewController: viewController)
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

#Preview {
    WithdrawalViewControllerPreview()
}
