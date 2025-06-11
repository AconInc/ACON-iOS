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
            savedSpotList: [],
            verifiedAreaList: [VerifiedAreaModel(id: 1, name: "")],
            possessingAcorns: 0
    )

    let maxNicknameLength: Int = 14

    var savedSpotList: [SavedSpotModel] = []
    
    // TODO: - 🍉 삭제
    var savedSpotDummy = [SavedSpotModel(id: 1, name: "식당이름딱아홉글자", image: nil),
                          SavedSpotModel(id: 2, name: "엽떡에허니콤보치즈추가", image: "https://cdn.kmecnews.co.kr/news/photo/202311/32217_20955_828.jpg"), SavedSpotModel(id: 3, name: "커비카페", image: "https://cdn.kmecnews.co.kr/news/photo/202311/32217_20955_828.jpg"), SavedSpotModel(id: 4, name: "커비카페", image: "https://cdn.kmecnews.co.kr/news/photo/202311/32217_20955_828.jpg"), SavedSpotModel(id: 5, name: "커비카페", image: "https://cdn.kmecnews.co.kr/news/photo/202311/32217_20955_828.jpg"), SavedSpotModel(id: 6, name: "커비카페", image: "https://cdn.kmecnews.co.kr/news/photo/202311/32217_20955_828.jpg"), SavedSpotModel(id: 7, name: "커비카페", image: "https://cdn.kmecnews.co.kr/news/photo/202311/32217_20955_828.jpg") ]

    
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
                    // 🍉 TODO: data.로 바꾸기
                    savedSpotList: savedSpotDummy)
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
                self.handleReissue {
                    self.getSavedSpots()
                }
            default:
//                onGetSavedSpotsSuccess.value = false
                // 🍉 TODO: 삭제
                savedSpotList = savedSpotDummy
                onGetSavedSpotsSuccess.value = true
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
                print("🥑nickname requestErr: \(error)")
                if error.code == 40901 {
                    self?.nicknameValidityMessageType = .nicknameTaken
                } else if error.code == 40051 {
                    self?.nicknameValidityMessageType = .invalidChar
                }
                self?.onGetNicknameValiditySuccess.value = false
            default:
                print("🥑 VM - Fail to getNicknameValidity")
                self?.onGetNicknameValiditySuccess.value = false
                return
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
                onPatchProfileSuccess.value = false
                return
            }
        }
    }

}
