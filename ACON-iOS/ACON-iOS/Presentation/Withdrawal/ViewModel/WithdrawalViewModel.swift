//
//  WithDrawViewModel.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 2/16/25.
//

import Foundation

final class WithdrawalViewModel {
    
    var inputText: ObservablePattern<String> = ObservablePattern(nil)

    func updateInputText(_ text: String) {
        inputText.value = text
    }
}
