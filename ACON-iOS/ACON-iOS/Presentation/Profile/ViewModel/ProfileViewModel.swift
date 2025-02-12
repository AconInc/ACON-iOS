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
    
    var verifiedAreaListEditing: ObservablePattern<[VerifiedAreaModel]> = ObservablePattern(nil)
    
    var userInfo = UserInfoModel(
        profileImageURL: "",
        nickname: "김유림",
        birthDate: nil,
        verifiedAreaList: [VerifiedAreaModel(id: 1, name: "유림동")],
        possessingAcorns: 0
    )
    
    let maxNicknameLength: Int = 16
    
    
    // MARK: - Initializer
    
    init() {
        verifiedAreaListEditing.value = userInfo.verifiedAreaList
    }
    
    
    // MARK: - Methods
    
    func updateUserInfo(newUserInfo: UserInfoEditModel) {
        userInfo.profileImageURL = newUserInfo.profileImageURL
        userInfo.nickname = newUserInfo.nickname
        userInfo.birthDate = newUserInfo.birthDate
        userInfo.verifiedAreaList = newUserInfo.verifiedAreaList
    }
    
}
