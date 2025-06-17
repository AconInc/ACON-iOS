//
//  Serviceable.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/17/25.
//

import UIKit

protocol Serviceable: AnyObject { }


// MARK: - Reissue

extension Serviceable {
    
    func handleReissue(retryAction: @escaping () -> Void) {
        Task {
            do {
                let success = try await AuthManager.shared.handleTokenRefresh()
                DispatchQueue.main.async {
                    if success {
                        print("❄️ 기존 서버통신 다시 성공")
                        retryAction()
                    } else {
                        for key in UserDefaults.standard.dictionaryRepresentation().keys {
                            UserDefaults.standard.removeObject(forKey: key.description)
                        }
                        self.navigateToSplash()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    for key in UserDefaults.standard.dictionaryRepresentation().keys {
                        UserDefaults.standard.removeObject(forKey: key.description)
                    }
                    self.navigateToSplash()
                }
            }
        }
    }
    
    private func navigateToSplash() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = SplashViewController()
        }
    }
    
}


// MARK: - Network Error

extension Serviceable {
    
    func handleNetworkError(retryAction: @escaping () -> Void) {
        Task {
            do {
                showNetworkErrorView(retryAction)
            }
        }
    }
    
    private func showNetworkErrorView(_ retryAction: @escaping () -> Void) {
        DispatchQueue.main.async {
            // NOTE: - 키보드 내리기
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }
            let networkErrorView = NetworkErrorView(retryAction)
            window.addSubview(networkErrorView)
            
            networkErrorView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
}
