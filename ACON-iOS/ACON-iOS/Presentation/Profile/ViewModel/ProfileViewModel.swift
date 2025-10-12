//
//  ProfileViewModel.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import Foundation
import Photos

final class ProfileViewModel: Serviceable {

    // MARK: - Properties

    var onLoginSuccess: ObservablePattern<Bool> = ObservablePattern(AuthManager.shared.hasToken)

    var onGetProfileSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var onGetSavedSpotsSuccess: ObservablePattern<Bool> = ObservablePattern(nil)

    var onGetNicknameValiditySuccess: ObservablePattern<Bool> = ObservablePattern(nil)

    var onPatchProfileSuccess: ObservablePattern<Bool> = ObservablePattern(nil)

    var profileImage: PhotoModel? = nil

    var nicknameValidityMessageType: ProfileValidMessageType = .none

    var userInfo = UserInfoModel(
            profileImage: "",
            nickname: "",
            birthDate: nil,
            savedSpotList: []
    )

    let maxNicknameLength: Int = 14

    var savedSpotList: [SavedSpotModel] = []

    // NOTE: 서버 오류로 401 뜰 때 재시도 루프에 빠지는 문제 방지
    private var uploadRetryCount = 0
    private let maxUploadRetries = 1


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

    func saveProfile() {
        self.uploadRetryCount = 0
        executeSaveProfileFlow()
    }

    func executeSaveProfileFlow() {
        print("Profile save attempt #\(uploadRetryCount + 1)")

        Task {
            do {
                var imageURL: String? = nil
                if let profileImage {
                    imageURL = try await uploadProfilePhoto(asset: profileImage.asset)
                }
                try await patchProfile(imageURL: imageURL)
                await MainActor.run { onPatchProfileSuccess.value = true }

            } catch PhotoManagerError.tokenExpired {
                guard self.uploadRetryCount < self.maxUploadRetries else {
                    print("🚨 Max retries reached. Stopping the loop.")
                    await MainActor.run { onPatchProfileSuccess.value = false }
                    return
                }
                self.uploadRetryCount += 1
                handleReissue { [weak self] in
                    self?.executeSaveProfileFlow()
                }
            } catch PhotoManagerError.networkError {
                handleNetworkError { [weak self] in
                    self?.executeSaveProfileFlow()
                }
            } catch {
                print("❌ An unhandled failure occurred: \(error.localizedDescription)")
                await MainActor.run { onPatchProfileSuccess.value = false }
            }
        }
    }

    func patchProfile(imageURL: String? = nil) async throws {
        let requestBody = PatchProfileRequest(
            profileImage: imageURL,
            nickname: userInfo.nickname,
            birthDate: userInfo.birthDate
        )

        try await withCheckedThrowingContinuation { continuation in
            ACService.shared.profileService.patchProfile(requestBody: requestBody) { response in
                switch response {
                case .success:
                    continuation.resume(returning: ())
                case .reIssueJWT:
                    continuation.resume(throwing: PhotoManagerError.tokenExpired)
                case .requestErr(let error):
                    continuation.resume(throwing: PhotoManagerError.requestError(error))
                case .networkFail:
                    continuation.resume(throwing: PhotoManagerError.networkError)
                default:
                    continuation.resume(throwing: PhotoManagerError.serverError)
                }
            }
        }
    }

    private func uploadProfilePhoto(asset: PHAsset) async throws -> String {
        return try await PhotoManager(imageType: .PROFILE).uploadImage(asset: asset)
    }

}
