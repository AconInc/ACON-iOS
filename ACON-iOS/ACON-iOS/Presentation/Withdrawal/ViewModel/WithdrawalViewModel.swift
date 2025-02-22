//
//  WithDrawViewModel.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/16/25.
//

import Foundation

final class WithdrawalViewModel: Serviceable {
    
    var selectedOption: ObservablePattern<String> = ObservablePattern(nil)
    var inputText: ObservablePattern<String> = ObservablePattern(nil)
    var shouldDismissKeyboard: ObservablePattern<Bool> = ObservablePattern(false)
    var ectOption: ObservablePattern<Bool> = ObservablePattern(false)
    
    let onSuccessWithdrawal: ObservablePattern<Bool> = ObservablePattern(nil)
    
    func updateSelectedOption(_ option: String?) {
        selectedOption.value = option
        
        if option == StringLiterals.Withdrawal.optionOthers {
            if let inputText = inputText.value, !inputText.isEmpty {
                ectOption.value = true
            } else {
                ectOption.value = false
            }
        } else if let optionValue = option, !optionValue.isEmpty {
            ectOption.value = true
            
        } else {
            ectOption.value = false
        }
    }
    
    func updateInputText(_ text: String?) {
        inputText.value = text
        
        if selectedOption.value == StringLiterals.Withdrawal.optionOthers {
            ectOption.value = (text?.isEmpty == false)
        }
    }
    
    func withdrawalAPI() {
        let refreshToken = UserDefaults.standard.string(forKey: StringLiterals.UserDefaults.refreshToken) ?? ""
        
        guard let reasonText = selectedOption.value else {
            print("⚠️")
            return
        }

        ACService.shared.withdrawalService.postWithdrawal(
            WithdrawalRequest(reason: reasonText, refreshToken: refreshToken)) { result in
            switch result {
            case .success:
                for key in UserDefaults.standard.dictionaryRepresentation().keys {
                    UserDefaults.standard.removeObject(forKey: key.description)
                }
                self.onSuccessWithdrawal.value = true
            case .reIssueJWT:
                self.handleReissue { [weak self] in
                    self?.withdrawalAPI()
                }
            default:
                self.onSuccessWithdrawal.value = false
            }
        }
    }
}

