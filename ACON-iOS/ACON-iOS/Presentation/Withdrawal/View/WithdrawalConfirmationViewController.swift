//
//  WithdrawalConfirmationViewController.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/17/25.
//

import UIKit

import SnapKit
import Then

final class WithdrawalConfirmationViewController: BaseViewController {
    
    private let confirmationView = WithdrawalConfirmationView()
    var viewModel: WithdrawalViewModel?
    var selectedReason: String?

    override func loadView() {
        view = confirmationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAction()
        bindViewModel()
    }
    
}


// MARK: - bind VM

extension WithdrawalConfirmationViewController {
    
    func bindViewModel() {
        viewModel?.onSuccessWithdrawal.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }
            
            if onSuccess {
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = SplashViewController()
                }
            } else {
                self.showDefaultAlert(title: "탈퇴 실패", message: "탈퇴에 실패했습니다.")
            }
        }
    }
    
}

extension WithdrawalConfirmationViewController {
    
    private func setAction() {
        confirmationView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        confirmationView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        confirmationView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func confirmButtonTapped() {
        viewModel?.withdrawalAPI()
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
}
