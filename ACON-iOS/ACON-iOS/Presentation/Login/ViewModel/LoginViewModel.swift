//
//  LoginViewModel.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/11/25.
//

import UIKit

import GoogleSignIn
import GoogleSignInSwift

class LoginViewModel {
    
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

                let idToken = user.idToken?.tokenString
                
                // TODO: - Send this IDToken to Backend
                print(idToken)
            }
        }
    }
     
}
