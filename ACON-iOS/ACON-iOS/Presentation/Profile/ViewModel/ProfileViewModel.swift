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
    
    var userInfo: ObservablePattern<UserInfoModel> = ObservablePattern(
        UserInfoModel(
            profileImageURL: "",
            nickname: "김유림",
            birthDate: nil,
            verifiedAreaList: [VerifiedAreaModel(id: 1, name: "유림동")],
            possessingAcorns: 0
        )
    )
    
    let maxNicknameLength: Int = 16
    
    
    // MARK: - Initializer
    
    init() {
        verifiedAreaListEditing.value = userInfo.value?.verifiedAreaList
    }
    
    
    // MARK: - Methods
    
    func updateUserInfo(newUserInfo: UserInfoEditModel) {
        userInfo.value?.profileImageURL = newUserInfo.profileImageURL
        userInfo.value?.nickname = newUserInfo.nickname
        userInfo.value?.birthDate = newUserInfo.birthDate
        userInfo.value?.verifiedAreaList = newUserInfo.verifiedAreaList
    }
    
}
