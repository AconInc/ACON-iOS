//
//  SceneDelegate.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/3/25.
//

import UIKit
import BranchSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        self.window?.rootViewController = SplashViewController()
        self.window?.makeKeyAndVisible()

        // NOTE:
        // Workaround for SceneDelegate `continueUserActivity` not getting called on cold start:
        if let userActivity = connectionOptions.userActivities.first {
            BranchScene.shared().scene(scene, continue: userActivity)
        } else if !connectionOptions.urlContexts.isEmpty {
            BranchScene.shared().scene(scene, openURLContexts: connectionOptions.urlContexts)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        // NOTE: 스플래시 (2.4초) 이후
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.checkUpdate()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    private func checkUpdate() {
        Task {
            let updateAvailable = await AppVersionManager.shared.checkMajorMinorVersion() == false
            if updateAvailable {
                await MainActor.run {
                    window?.rootViewController?.showDefaultAlert(title: "업데이트 알림",
                                                                                    message: "지금 앱스토어에서 새로워진 acon을 만나보세요!",
                                                                                    okText: "업데이트",
                                                                                    isCancelAvailable: true,
                                                                 cancelText: "나중에") {
                        AppVersionManager.shared.openAppStore()
                    }
                }
            }
        }
    }

    func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {
        scene.userActivity = NSUserActivity(activityType: userActivityType)
        scene.delegate = self
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        BranchScene.shared().scene(scene, continue: userActivity)

        // NOTE: scene이 딥링크 클로저보다 먼저 불리기때문에 0.5초 지연
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            DeepLinkManager.shared.presentSpotDetail()
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        BranchScene.shared().scene(scene, openURLContexts: URLContexts)
    }

}

