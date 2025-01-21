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
    
    var onLoginSuccess: ObservablePattern<Bool> = ObservablePattern(nil)
    
    var idToken: String = ""
    
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
                
                self.idToken = user.idToken?.tokenString ?? ""
            }
        }
    }
    
    func appleSignIn(userInfo: ASAuthorizationAppleIDCredential) {
        if let idTokenData = userInfo.identityToken,
           let idToken = String(data: idTokenData, encoding: .utf8) {
            print(idToken)
        }
    }
    
}
