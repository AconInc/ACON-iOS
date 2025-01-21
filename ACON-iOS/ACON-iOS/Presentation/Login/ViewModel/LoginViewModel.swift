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

class LoginViewModel {
    
    var onSuccessLogin: ObservablePattern<Bool> = ObservablePattern(nil)
    
    func googleSignIn(presentingViewController: UIViewController) {
        let clientID = Config.googleClientID
                
        let config = GIDConfiguration(clientID: clientID)
                
        GIDSignIn.sharedInstance.configuration = config
                
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }

            signInResult.user.refreshTokensIfNeeded { user, error in
                guard error == nil else { return }
                guard let user = user else { return }
                
                let idToken = user.idToken?.tokenString ?? ""
                self.postLogin(socialType: SocialType.GOOGLE.rawValue, idToken: idToken)
            }
        }
    }
    
    func appleSignIn(userInfo: ASAuthorizationAppleIDCredential) {
        if let idTokenData = userInfo.identityToken,
           let idToken = String(data: idTokenData, encoding: .utf8) {
            postLogin(socialType: SocialType.APPLE.rawValue, idToken: idToken)
        }
    }
    
    // TODO: - 앱잼 기간 내에는 우선 accessToken만 받아옴 - 나중에 refreshToken 받아오기
    func postLogin(socialType: String, idToken: String) {
        ACService.shared.authService.postLogin(PostLoginRequest(socialType: socialType, idToken: idToken)){ [weak self] response in
            switch response {
            case .success(let data):
                UserDefaults.standard.set(data.accessToken, forKey: StringLiterals.UserDefaults.accessToken)
                self?.onSuccessLogin.value = true
            default:
                print("VM - Failed To postLogin")
                self?.onSuccessLogin.value = false
                return
            }
        }
    }
    
}
