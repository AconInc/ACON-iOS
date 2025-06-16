//
//  AppDelegate.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/3/25.
//

import UIKit
import Firebase
import FirebaseCrashlytics
import BranchSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        /// 엠플리튜드 초기화
        AmplitudeManager.shared.initialize()
        
        /// 파이어베이스 초기화
        FirebaseApp.configure()
        
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        
        /// 구글 애즈 초기화
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            GoogleAdsManager.shared.initialize()
        }
        
        /// Branch io 초기화
        /// This version of `initSession` includes the source UIScene in the callback
        BranchScene.shared().initSession(launchOptions: launchOptions, registerDeepLinkHandler: { (params, error, scene) in
            print("🔗 Branch 딥링크 데이터:", params ?? [:])
        })
        
        return true
    }

    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    // MARK: - 화면 세로 고정
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }

}

