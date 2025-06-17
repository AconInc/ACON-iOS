//
//  WithdrawalConfirmationViewController.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/17/25.
//

import UIKit

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
                NavigationUtils.navigateToSplash()
                AmplitudeManager.shared.reset()
            } else {
                self.showDefaultAlert(title: "탈퇴 실패", message: "탈퇴에 실패했습니다.")
            }
        }
    }
    
}


// MARK: - setAction

private extension WithdrawalConfirmationViewController {
    
    func setAction() {
        confirmationView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        confirmationView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    func confirmButtonTapped() {
        AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.serviceWithdraw, properties: ["delete_id": true])
        viewModel?.withdrawalAPI()
    }
    
}
