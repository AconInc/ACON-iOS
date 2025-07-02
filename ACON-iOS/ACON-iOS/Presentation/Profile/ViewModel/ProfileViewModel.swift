//
//  ProfileViewModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import Foundation

final class ProfileViewModel: Serviceable {

    // MARK: - Properties

    var onLoginSuccess: ObservablePattern<Bool> = ObservablePattern(AuthManager.shared.hasToken)

    var onGetProfileSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var onGetSavedSpotsSuccess: ObservablePattern<Bool> = ObservablePattern(nil)

    var onGetNicknameValiditySuccess: ObservablePattern<Bool> = ObservablePattern(nil)

    var onSuccessGetPresignedURL: ObservablePattern<Bool> = ObservablePattern(nil)

    var onSuccessPutProfileImageToPresignedURL: ObservablePattern<Bool> = ObservablePattern(nil)

    var onPatchProfileSuccess: ObservablePattern<Bool> = ObservablePattern(nil)

    var presignedURLInfo: PresignedURLModel = PresignedURLModel(fileName: "",
                                                                presignedURL: "")

    var nicknameValidityMessageType: ProfileValidMessageType = .none

    var userInfo = UserInfoModel(
            profileImage: "",
            nickname: "",
            birthDate: nil,
            savedSpotList: []
    )

    let maxNicknameLength: Int = 14

    var savedSpotList: [SavedSpotModel] = []
    
    
    // MARK: - Methods

    func updateUserInfo(nickname: String, birthDate: String?) {
        userInfo.nickname = nickname
        userInfo.birthDate = birthDate
    }

    
    // MARK: - Networking

    func getProfile() {
        ACService.shared.profileService.getProfile { [weak self] response in
            guard let self = self else { return }

            switch response {
            case .success(let data):
                let newUserInfo = UserInfoModel(
                    profileImage: data.profileImage,
                    nickname: data.nickname,
                    birthDate: data.birthDate,
                    savedSpotList: data.savedSpotList.map {
                        SavedSpotModel(id: $0.spotId,
                                       name: $0.name,
                                       image: $0.image)
                    })
                userInfo = newUserInfo
                onGetProfileSuccess.value = true
            case .reIssueJWT:
                self.handleReissue { [weak self] in
                    self?.getProfile()
                }
            default:
                self.handleNetworkError { [weak self] in
                    self?.getProfile()
                }
            }
        }
    }
    
    func getSavedSpots() {
        ACService.shared.profileService.getSavedSpots { [weak self] response in
            guard let self = self else { return }

            switch response {
            case .success(let data):
                let newSavedSpotList: [SavedSpotModel] = data.savedSpotList.map {
                    SavedSpotModel(id: $0.spotId,
                                   name: $0.name,
                                   image: $0.image)
                }
                savedSpotList = newSavedSpotList
                onGetSavedSpotsSuccess.value = true
            case .reIssueJWT:
                self.handleReissue { [weak self] in
                    self?.getSavedSpots()
                }
            default:
                self.handleNetworkError { [weak self] in
                    self?.getSavedSpots()
                }
            }
        }
    }

    func getNicknameValidity(nickname: String) {
        let parameter = GetNicknameValidityRequest(nickname: nickname)

        ACService.shared.profileService.getNicknameValidity(parameter: parameter) { [weak self] response in
            switch response {
            case .success(_):
                self?.onGetNicknameValiditySuccess.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.getNicknameValidity(nickname: nickname)
                }
            case .requestErr(let error):
                if error.code == 40901 {
                    self?.nicknameValidityMessageType = .nicknameTaken
                } else if error.code == 40051 {
                    self?.nicknameValidityMessageType = .invalidChar
                } else {
                    self?.handleNetworkError { [weak self] in
                        self?.getNicknameValidity(nickname: nickname)
                    }
                }
                self?.onGetNicknameValiditySuccess.value = false
            default:
                self?.handleNetworkError { [weak self] in
                    self?.getNicknameValidity(nickname: nickname)
                }
            }
        }
    }

    func getProfilePresignedURL() {
        ACService.shared.imageService.getPresignedURL(
            parameter: GetPresignedURLRequest(imageType: ImageType.PROFILE.rawValue)
        ) { [weak self] response in
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
                self.handleNetworkError {
                    self.getProfilePresignedURL()
                }
            }
        }
    }

    func putProfileImageToPresignedURL(imageData: Data) {
        ACService.shared.imageService.putImageToPresignedURL(requestBody: PutImageToPresignedURLRequest(presignedURL: presignedURLInfo.presignedURL, imageData: imageData)) { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            case .success(_):
                onSuccessPutProfileImageToPresignedURL.value = true
            case .reIssueJWT:
                self.handleReissue {
                    self.putProfileImageToPresignedURL(imageData: imageData)
                }
            default:
                self.handleNetworkError {
                    self.putProfileImageToPresignedURL(imageData: imageData)
                }
            }
        }
    }

    func patchProfile() {
        let requestBody = PatchProfileRequest(
            profileImage: userInfo.profileImage.isEmpty ? nil : userInfo.profileImage,
            nickname: userInfo.nickname,
            birthDate: userInfo.birthDate
        )

        ACService.shared.profileService.patchProfile(requestBody: requestBody) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success:
                onPatchProfileSuccess.value = true
            case .reIssueJWT:
                self.handleReissue {
                    self.patchProfile()
                }
            default:
                self.handleNetworkError {
                    self.patchProfile()
                }
            }
        }
    }

}
