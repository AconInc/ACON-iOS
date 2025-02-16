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
    
    func updateSelectedOption(_ option: String) {
        selectedOption.value = option
        
        if option == StringLiterals.Withdrawal.optionOthers {
            inputText.value = ""
        } else {
            inputText.value = nil
        }
    }
    
    func updateInputText(_ text: String) {
        if selectedOption.value == StringLiterals.Withdrawal.optionOthers {
            inputText.value = text
        }
    }
}
