//
//  AlertHandler.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/17/25.
//

import UIKit

class AlertHandler {
    
    static let shared = AlertHandler()
    
    
    // MARK: - 이미지 Alert
    
    func showLocationAccessFailImageAlert(from viewController: UIViewController) {
        let customAlertImageViewController = CustomAlertImageViewController()
        customAlertImageViewController.configure(with: .locationAccessFailImage)
        customAlertImageViewController.modalPresentationStyle = .overFullScreen
        customAlertImageViewController.modalTransitionStyle = .crossDissolve
        viewController.present(customAlertImageViewController, animated: true, completion: nil)
    }
    
    
    // MARK: - 취향 분석 중단 Alert
    
    func showStoppedPreferenceAnalysisAlert(from viewController: UIViewController) {
        let customAlertViewController = CustomAlertViewController()
        customAlertViewController.configure(with: .stoppedPreferenceAnalysis)
        
        customAlertViewController.onClose = {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = ACTabBarController()
            }
        }
        
        presentAlert(customAlertViewController, from: viewController)
    }
    
    
    // MARK: - 위치 권한 실패 Alert
    
    func showLocationAccessFailAlert(from viewController: UIViewController) {
        let customAlertViewController = CustomAlertViewController()
        customAlertViewController.configure(with: .locationAccessDenied)
        
        customAlertViewController.onSettings = {
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(settingsURL) else { return }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        
        presentAlert(customAlertViewController, from: viewController)
    }
    
    
    // MARK: - 업로드 중단 Alert
    
    func showUploadExitAlert(from viewController: UIViewController) {
        let customAlertViewController = CustomAlertViewController()
        customAlertViewController.configure(with: .uploadExit)
        customAlertViewController.onClose = {
            var topController: UIViewController = viewController
            while let presenting = topController.presentingViewController {
                topController = presenting
            }
            topController.dismiss(animated: true)
        }
        presentAlert(customAlertViewController, from: viewController)
    }
    

    // MARK: - 로그아웃 Alert
    
    func showLogoutAlert(from viewController: UIViewController,
                         action: @escaping () -> Void) {
        let alertVC = CustomAlertViewController()
        alertVC.configure(with: .logout)
        alertVC.onSettings = action
        presentAlert(alertVC, from: viewController)
    }
    
    
    // MARK: - 사진 권한 Alert
    
    func showLibraryAccessFailAlert(from viewController: UIViewController) {
        let customAlertViewController = CustomAlertViewController()
        customAlertViewController.configure(with: .libraryAccessDenied)
        
        customAlertViewController.onSettings = {
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(settingsURL) else { return }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        customAlertViewController.onClose = {
            customAlertViewController.dismiss(animated: true) {
                if let tabBarController = viewController as? ACTabBarController,
                   let navController = tabBarController.selectedViewController as? UINavigationController,
                   let profileEditVC = navController.viewControllers.first(where: { $0 is ProfileEditViewController }) as? ProfileEditViewController {
                    navController.popToViewController(profileEditVC, animated: true)
                }
            }
        }
        presentAlert(customAlertViewController, from: viewController)
    }
    
    
    // MARK: - 인증동네 삭제 Alert
    
    func showWillYouDeleteVerifiedAreaAlert(from viewController: UIViewController,
                                            areaName: String,
                                            action: @escaping () -> Void) {
        let alertVC = CustomAlertTitleAndButtonsViewController()
        alertVC.configure(with: .deleteVerifiedArea)
        alertVC.reConfigureTitle(
            title: areaName + StringLiterals.LocalVerification.willYouDeleteThis
        )
        alertVC.onSettings = action
        presentAlert(alertVC, from: viewController)
    }
    
    func showWillYouChangeVerifiedAreaAlert(from viewController: UIViewController,
                                            action: @escaping () -> Void) {
        let alertVC = CustomAlertViewController()
        alertVC.configure(with: .changeVerifiedArea)
        alertVC.onSettings = action
        presentAlert(alertVC, from: viewController)
    }
    
}


// MARK: - Alert 프리젠테이션 공통 로직

private extension AlertHandler {
    
    func presentAlert(_ alert: CustomAlertViewController, from viewController: UIViewController) {
        alert.modalPresentationStyle = .overFullScreen
        alert.modalTransitionStyle = .crossDissolve
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func presentAlert(_ alert: CustomAlertTitleAndButtonsViewController, from viewController: UIViewController) {
        alert.modalPresentationStyle = .overFullScreen
        alert.modalTransitionStyle = .crossDissolve
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
