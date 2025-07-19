//
//  SemiShortModalType.swift
//  ACON-iOS
//
//  Created by 이수민 on 7/18/25.
//

import Foundation

enum SemiShortModalType: CaseIterable {
    
    case localVerificationReminder
    case withdrawalConfirmation
    
    var title: String {
        switch self {
        case .localVerificationReminder:
            return StringLiterals.LocalVerificationModal.title
        case .withdrawalConfirmation:
            return StringLiterals.WithdrawalConfirmation.title
        }
    }
    
    var description: String {
        switch self {
        case .localVerificationReminder:
            return StringLiterals.LocalVerificationModal.description
        case .withdrawalConfirmation:
            return StringLiterals.WithdrawalConfirmation.description
        }
    }
    
    var cancelButtonTitle: String {
        switch self {
        case .localVerificationReminder:
            return StringLiterals.LocalVerificationModal.cancel
        case .withdrawalConfirmation:
            return StringLiterals.WithdrawalConfirmation.cancelButtonTitle
        }
    }
    
    var confirmButtonTitle: String {
        switch self {
        case .localVerificationReminder:
            return StringLiterals.LocalVerificationModal.confirm
        case .withdrawalConfirmation:
            return StringLiterals.WithdrawalConfirmation.confirmButtonTitle
        }
    }
    
}
