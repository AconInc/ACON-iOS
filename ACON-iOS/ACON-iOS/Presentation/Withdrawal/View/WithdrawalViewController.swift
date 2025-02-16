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

    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let reasonTitleLabel = UILabel()
    private let reasonDescriptionLabel = UILabel()
    private let optionsTableView = WithdrawalTableView()
    private let submitButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
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
//                $0.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
                $0.setAttributedTitle(text: "제출",
                                      style: ACFont.h8,
                                      color: .gray6,
                                      for: .normal)
            }
    }

    override func setHierarchy() {
        super.setHierarchy()

        view.addSubviews(backButton,
                         titleLabel,
                         reasonTitleLabel,
                         reasonDescriptionLabel,
                         optionsTableView,
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

        submitButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(52)
        }
    }

  
}

import SwiftUI

struct WithdrawalViewControllerPreview: PreviewProvider {
    static var previews: some View {
        WithdrawalViewController().toPreview()
    }
}

extension UIViewController {
    func toPreview() -> some View {
        UIViewControllerPreview(viewController: self)
    }
}

struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController

    init(viewController: ViewController) {
        self.viewController = viewController
    }

    func makeUIViewController(context: Context) -> ViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) { }
}
