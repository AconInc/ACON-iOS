//
//  LoginViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/11/25.
//

import UIKit

import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

class LoginViewModel: Serviceable {
    
    var onSuccessLogin: ObservablePattern<Bool> = ObservablePattern(nil)
    
    func googleSignIn(presentingViewController: UIViewController) {
        // NOTE: - webClientID: 서버 전송용 -> 토큰 발급에 사용
        // NOTE: - clientID: iOS 앱 인증용 (네이티브 로그인 플로우)
        let clientID = Config.googleClientID
        let webClientID = Config.googleWebClientID
        
        // NOTE: - serverClientID < 프로퍼티가 서버 전송용
        let config = GIDConfiguration(clientID: clientID,
                                    serverClientID: webClientID)
                
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }

            // NOTE: - serverClientID가 audience
            signInResult.user.refreshTokensIfNeeded { user, error in
                guard error == nil else { return }
                guard let user = user else { return }
                
                let idToken = user.idToken?.tokenString ?? ""
                self.postLogin(socialType: SocialType.GOOGLE.rawValue,
                               idToken: idToken)
            }
        }
    }
    
    func appleSignIn(userInfo: ASAuthorizationAppleIDCredential) {
        if let idTokenData = userInfo.identityToken,
           let idToken = String(data: idTokenData, encoding: .utf8) {
            postLogin(socialType: SocialType.APPLE.rawValue, idToken: idToken)
        }
    }
    
    func postLogin(socialType: String, idToken: String) {
        ACService.shared.authService.postLogin(PostLoginRequest(socialType: socialType, idToken: idToken)){ [weak self] response in
            switch response {
            case .success(let data):
                UserDefaultsUtils.set(data.accessToken, forKey: .accessToken)
                UserDefaultsUtils.set(data.refreshToken, forKey: .refreshToken)
                UserDefaultsUtils.set(data.hasVerifiedArea, forKey: .hasVerifiedArea)
                UserDefaultsUtils.set(data.hasPreference, forKey: .hasPreference)

                // NOTE: 기존 유저가 앱 재설치 시 서비스 온보딩 노출 X
                // NOTE: 기존 유저인지는 취향탐색 또는 지역인증을 했는지로 판단
                if !(UserDefaultsUtils.get(Bool.self, forKey: .hasSeenTutorial) ?? false) {
                    UserDefaultsUtils.set((data.hasPreference || data.hasVerifiedArea), forKey: .hasSeenTutorial)
                }

                AuthManager.shared.updateLastTokenRefreshDate()
                TokenLogger.shared.log(.saved(tokenPrefix: String(data.accessToken.prefix(10))))

                AmplitudeManager.shared.setUserID(data.externalUUID)
                AmplitudeManager.shared.setUserProperty(userProperties: ["id": data.externalUUID])
                self?.onSuccessLogin.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postLogin(socialType: socialType, idToken: idToken)
                }
            case .networkFail:
                self?.handleNetworkError { [weak self] in
                    self?.postLogin(socialType: socialType, idToken: idToken)
                }
            default:
                self?.onSuccessLogin.value = false
            }
        }
    }
    
}
