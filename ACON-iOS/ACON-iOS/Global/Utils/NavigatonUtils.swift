//
//  NavigatonUtils.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/17/25.
//

import UIKit

struct NavigationUtils {
    
    static func navigateToTabBar() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = ACTabBarController()
        }
    }

    static func navigateToSplash() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = SplashViewController()
        }
    }

    static func popToParentVC(from currentVC: UIViewController, targetVCType: UIViewController.Type) {
        guard let navigationController = currentVC.navigationController else { return }
        let vcStack = navigationController.viewControllers
            
        for vc in vcStack {
            if type(of: vc) == targetVCType {
                navigationController.popToViewController(vc, animated: true)
                return
            }
        }
    }
    
}
