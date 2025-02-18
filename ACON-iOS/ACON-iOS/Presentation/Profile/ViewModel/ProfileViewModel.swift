//
//  ProfileViewModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import Foundation

class ProfileViewModel: Serviceable {
    
    // MARK: - Properties
    
    var onLoginSuccess: ObservablePattern<Bool> = ObservablePattern(AuthManager.shared.hasToken)
    
    var onGetProfileSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var verifiedAreaListEditing: ObservablePattern<[VerifiedAreaModel]> = ObservablePattern(nil) //TODO: 삭제
    
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
        verifiedAreaListEditing.value = userInfo.verifiedAreaList // TODO: 삭제
    }
    
    
    // MARK: - Methods
    
    func updateUserInfo(newUserInfo: UserInfoEditModel) {
        userInfo.profileImageURL = newUserInfo.profileImageURL
        userInfo.nickname = newUserInfo.nickname
        userInfo.birthDate = newUserInfo.birthDate
        userInfo.verifiedAreaList = newUserInfo.verifiedAreaList
    }
    
    
    // MARK: - Networking
    
    func getProfile() {
        ACService.shared.profileService.getProfile { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                let newUserInfo = UserInfoModel(
                    profileImageURL: data.image,
                    nickname: data.nickname,
                    birthDate: data.birthDate,
                    verifiedAreaList: data.verifiedAreaList.map {
                        return VerifiedAreaModel(id: $0.id, name: $0.name)
                    },
                    possessingAcorns: data.leftAcornCount
                )
                userInfo = newUserInfo
                onGetProfileSuccess.value = true
            case .reIssueJWT:
                self.handleReissue {
                    self.getProfile()
                }
            default:
                onGetProfileSuccess.value = false
            }
        }
    }
    
}
