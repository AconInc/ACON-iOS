//
//  WithdrawalConfirmationViewController.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/17/25.
//
import UIKit

import SnapKit
import Then

final class WithdrawalConfirmationViewController: UIViewController {

    private let confirmationView = WithdrawalConfirmationView()

    override func loadView() {
        view = confirmationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setActions()
    }

    private func setActions() {
        confirmationView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        confirmationView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        confirmationView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func confirmButtonTapped() {
        // 탈퇴 처리 로직 (실제 앱에서는 서버와 통신)
        dismiss(animated: true)
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}
