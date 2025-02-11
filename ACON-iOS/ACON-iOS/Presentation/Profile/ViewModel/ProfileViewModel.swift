//
//  ProfileViewModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import Foundation

class ProfileViewModel {
    
    // MARK: - Properties
    
    var onLoginSuccess: ObservablePattern<Bool> = ObservablePattern(AuthManager.shared.hasToken)
    
    var verifiedAreaEditing: ObservablePattern<String> = ObservablePattern(nil)
    
    var userInfo = UserInfoModel(
        profileImageURL: "",
        nickname: "김유림",
        birthDate: nil,
        verifiedArea: "유림동",
        possessingAcorns: 0
    )
    
    let maxNicknameLength: Int = 16
    
    
    // MARK: - Initializer
    
    init() {
        verifiedAreaEditing.value = userInfo.verifiedArea
    }
    
}
