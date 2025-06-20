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
        self.window?.overrideUserInterfaceStyle = .dark
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
            let updateAvailable = await AppVersionManager.shared.checkUpdateAvailable()
            
            if updateAvailable {
                if await AppVersionManager.shared.getAppUpdate() {
                    // NOTE: - 강제 업데이트
                    await MainActor.run {
                        window?.rootViewController?.presentACAlert(.essentialUpdate, longAction: {
                            AppVersionManager.shared.openAppStore()
                        })
                    }
                } else {
                    // NOTE: - 24시간 체크
                    let lastAlertTime = UserDefaults.standard.object(forKey: "lastUpdateAlertTime") as? Date
                    let now = Date()
                    
                    if let lastTime = lastAlertTime {
                        let timeDifference = now.timeIntervalSince(lastTime)
                        let hourDifference = timeDifference / 3600
                        
                        // NOTE: - 24시간 이내에 이미 함
                        if hourDifference < 24 { return }
                    }
                    
                    // NOTE: - 일반 업데이트
                    await MainActor.run {
                        window?.rootViewController?.presentACAlert(.plainUpdate, rightAction: {
                            AppVersionManager.shared.openAppStore()
                        })
                        UserDefaults.standard.set(now, forKey: "lastUpdateAlertTime")
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
