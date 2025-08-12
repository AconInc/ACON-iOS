//
//  VerificationReminderViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 7/18/25.
//

import UIKit

final class VerificationReminderViewController: BaseViewController {
    
    private let modalView = SemiShortModalView(semiShortModalType: .localVerificationReminder)
    
    private var viewModel = LocalVerificationViewModel(flowType: .setting)
    
    override func loadView() {
        view = modalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAction()
    }
    
}


// MARK: - setAction

private extension VerificationReminderViewController {
    
    func setAction() {
        modalView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        modalView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func cancelButtonTapped() {
        let now = Date()
        UserDefaults.standard.set(now, forKey: StringLiterals.UserDefaults.lastLocalVerificationAlertTime)
        dismiss(animated: true)
    }
    
    @objc
    func confirmButtonTapped() {
        NavigationUtils.navigateToOnboardingLocalVerification()
    }
    
}
