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
    
    var hasVerifiedArea: Bool = false
    
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
                UserDefaults.standard.set(data.accessToken, forKey: StringLiterals.UserDefaults.accessToken)
                UserDefaults.standard.set(data.refreshToken, forKey: StringLiterals.UserDefaults.refreshToken)
                UserDefaults.standard.set(data.hasVerifiedArea, forKey: StringLiterals.UserDefaults.hasVerifiedArea)
                self?.hasVerifiedArea = data.hasVerifiedArea
                // TODO: - (중요) 추후 진짜 유저 아이디로 변경
                AmplitudeManager.shared.setUserID("testsumin")
                AmplitudeManager.shared.setUserProperty(userProperties: ["id": "testsumin"])
                self?.onSuccessLogin.value = true
            case .reIssueJWT:
                self?.handleReissue { [weak self] in
                    self?.postLogin(socialType: socialType, idToken: idToken)
                }
            default:
                print("VM - Failed To postLogin")
                self?.onSuccessLogin.value = false
                return
            }
        }
    }
    
}
