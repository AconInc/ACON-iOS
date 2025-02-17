//
//  WithDrawViewModel.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/16/25.
//

import Foundation

final class WithdrawalViewModel {
    
    var selectedOption: ObservablePattern<String> = ObservablePattern(nil)
    var inputText: ObservablePattern<String> = ObservablePattern(nil)
    var shouldDismissKeyboard: ObservablePattern<Bool> = ObservablePattern(false)
    
    func updateInputText(_ text: String) {
        if selectedOption.value == StringLiterals.Withdrawal.optionOthers {
            inputText.value = text
            
            if text.contains("\n") {
                shouldDismissKeyboard.value = true
                inputText.value = text.replacingOccurrences(of: "\n", with: "") 
            }
        }
    }
    
    // TODO: inputText -> selectedOption
    func updateSelectedOption(_ option: String?) {
        selectedOption.value = option?.isEmpty == true ? nil : option
            inputText.value = nil
        }
    
    // TODO: make api
    func postWithdrawal() {
        print("selectedOption: \(String(describing: selectedOption.value))")
    }
    
}

