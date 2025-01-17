//
//  AlertHandler.swift
//  ACON-iOS
//
//  Created by Jaehyun Ahn on 1/17/25.
//

import UIKit

class AlertHandler {
    
    /// 이미지 alert
    func showLocationAccessFailImageAlert(from viewController: UIViewController) {
            let customAlertImageView = CustomAlertImageView()
            customAlertImageView.onClose = {
                print("위치 권한 실패: 이미지 알림 닫기")
            }
        
        customAlertImageView.modalPresentationStyle = .overFullScreen
        customAlertImageView.modalTransitionStyle = .crossDissolve
        viewController.present(customAlertImageView, animated: true, completion: nil)
    }
    
    /// 취향 분석 중단 Alert
    func showStoppedPreferenceAnalysisAlert(from viewController: UIViewController) {
        let customAlertView = CustomAlertView()
        customAlertView.configure(with: .stoppedPreferenceAnalysis)
        
        customAlertView.onClose = {
            let mainViewController = ACTabBarController()
            mainViewController.modalPresentationStyle = .fullScreen
            viewController.present(mainViewController, animated: true)
        }
        
        customAlertView.onSettings = {
            print("취향 분석 중단: 계속하기")
        }
        
        presentAlert(customAlertView, from: viewController)
    }
    
    /// 위치 권한 실패 Alert
    func showLocationAccessFailAlert(from viewController: UIViewController) {
        let customAlertView = CustomAlertView()
        customAlertView.configure(with: .locationAccessDenied)
        customAlertView.onClose = {
            print("위치 권한 실패: 그만두기")
        }
        
        // NOTE: degub i will fix
        customAlertView.onSettings = {
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                print("Failed to create settings URL")
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: { success in
                    if success {
                        print("Successfully navigated to settings")
                    } else {
                        print("Failed to open settings")
                    }
                })
            } else {
                print("Cannot open settings URL")
            }
        }

        presentAlert(customAlertView, from: viewController)
    }
    
    /// 업로드 중단 Alert
    func showUploadExitAlert(from viewController: UIViewController) {
        let customAlertView = CustomAlertView()
        customAlertView.configure(with: .uploadExit)
        customAlertView.onClose = {
            let mainViewController = ACTabBarController()
            mainViewController.modalPresentationStyle = .fullScreen
            viewController.present(mainViewController, animated: true)
        }
        customAlertView.onSettings = {
            print("업로드 중단: 계속하기")
        }
        presentAlert(customAlertView, from: viewController)
    }
    
    /// 리뷰 중단 Alert
    func showReviewExitAlert(from viewController: UIViewController) {
        let customAlertView = CustomAlertView()
        customAlertView.configure(with: .reviewExit)
        customAlertView.onClose = {
            let mainViewController = ACTabBarController()
            mainViewController.modalPresentationStyle = .fullScreen
            viewController.present(mainViewController, animated: true)
        }
        customAlertView.onSettings = {
            print("리뷰 중단: 계속하기")
        }
        presentAlert(customAlertView, from: viewController)
    }
    
    /// Alert 프리젠테이션 공통 로직
    private func presentAlert(_ alert: CustomAlertView, from viewController: UIViewController) {
        alert.modalPresentationStyle = .overFullScreen
        alert.modalTransitionStyle = .crossDissolve
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
