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
    
    var onGetNicknameValiditySuccess: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var onSuccessGetPresignedURL: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var onSuccessPutProfileImageToPresignedURL: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var onPatchProfileSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var presignedURLInfo: PresignedURLModel = PresignedURLModel(fileName: "",
                                                                presignedURL: "")
    
    var verifiedAreaListEditing: ObservablePattern<[VerifiedAreaModel]> = ObservablePattern(nil)
    
    var nicknameValidityMessageType: ProfileValidMessageType = .none
    
    var userInfo = UserInfoModel(
            profileImage: "",
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
    
    func updateUserInfo(_ newUserInfo: UserInfoEditModel) {
        // TODO: - presignedurl string
        userInfo.profileImage = ""
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
                    profileImage: data.image,
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
    
    func getNicknameValidity(nickname: String) {
        let parameter = GetNicknameValidityRequestQuery(nickname: nickname)
        
        ACService.shared.profileService.getNicknameValidity(parameter: parameter) { [weak self] response in
            switch response {
            case .success(_):
                self?.onGetNicknameValiditySuccess.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.getNicknameValidity(nickname: nickname)
                }
            case .requestErr(let error):
                print("🥑nickname requestErr: \(error)")
                if error.code == 40901 {
                    self?.nicknameValidityMessageType = .nicknameTaken
                } // TODO: 40051 반영
                self?.onGetNicknameValiditySuccess.value = false
            default:
                print("🥑 VM - Fail to getNicknameValidity")
                self?.onGetNicknameValiditySuccess.value = false
                return
            }
        }
    }
    
    func getProfilePresignedURL() {
        ACService.shared.imageService.getPresignedURL(parameter: GetPresignedURLRequest(imageType: ImageType.PROFILE.rawValue)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                presignedURLInfo = PresignedURLModel(fileName: data.fileName,
                                                     presignedURL: data.preSignedUrl)
                self.userInfo.profileImage = data.fileName
                onSuccessGetPresignedURL.value = true
            case .reIssueJWT:
                self.handleReissue {
                    self.getProfilePresignedURL()
                }
            default:
                onSuccessGetPresignedURL.value = false
            }
        }
    }
    
    func putProfileImageToPresignedURL(imageData: Data) {
        ACService.shared.imageService.putImageToPresignedURL(requestBody: PutImageToPresignedURLRequest(presignedURL: presignedURLInfo.presignedURL, imageData: imageData)) { [weak self] isSuccess in
            guard let self = self else { return }
            if isSuccess {
                onSuccessPutProfileImageToPresignedURL.value = true
            } else {
                onSuccessPutProfileImageToPresignedURL.value = false
            }
        }
    }
    
    func patchProfile(userInfo: UserInfoEditModel) {
        let requestBody = PatchProfileRequest(
            profileImage: presignedURLInfo.presignedURL,
            nickname: userInfo.nickname,
            birthDate: userInfo.birthDate
        )
        
        ACService.shared.profileService.patchProfile(requestBody: requestBody) { [weak self] response in
            switch response {
            case .success(_):
                self?.onPatchProfileSuccess.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.patchProfile(userInfo: userInfo)
                }
            default:
                print("🥑 VM - Fail to patchProfile")
                self?.onPatchProfileSuccess.value = false
                return
            }
        }
    }
    
}
