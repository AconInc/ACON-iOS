//
//  DeepLinkManager.swift
//  ACON-iOS
//
//  Created by 김유림 on 6/17/25.
//

import UIKit

final class DeepLinkManager {

    static let shared = DeepLinkManager()
    private init() {}

    var deepLinkParams: [String: AnyObject]?

    func getSpotID() -> Int64? {
        // NOTE: 딥링크는 한 번만 사용되도록 초기화
        defer { deepLinkParams = nil }

        // NOTE: iOS 링크
        if let spotIDInt64 = deepLinkParams?["spotId"] as? Int64 {
            return spotIDInt64
        }
        // NOTE: Android 링크
        else if let spotIDString = deepLinkParams?["spotId"] as? String,
                  let spotIDInt64 = Int64(spotIDString) {
            return spotIDInt64
        } else {
            return nil
        }
    }

    func isFreshDeepLink() -> Bool {
        guard let timeStamp = getClickTimeStamp() else { return false }

        let currentTime = Date().timeIntervalSince1970
        let timeDelta = currentTime - timeStamp
        let isFresh: Bool = timeDelta >= 0 && timeDelta < 20
        print("🔗⏱️ stamp: \(timeStamp), current: \(currentTime), delta: \(timeDelta)s, isFresh: \(isFresh)")

        return isFresh
    }

    func presentSpotDetail() {
        if let spotID = getSpotID() {
            DispatchQueue.main.async {
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                   let window = sceneDelegate.window,
                   let topVC = window.rootViewController?.getTopViewController() {
                    let spotDetailVC = SpotDetailViewController(spotID, isDeepLink: true)
                    spotDetailVC.modalPresentationStyle = .fullScreen
                    topVC.present(spotDetailVC, animated: true)
                }
            }
        }
    }

}


// MARK: - Helper

private extension DeepLinkManager {

    func getClickTimeStamp() -> TimeInterval? {
        guard let rawValue = deepLinkParams?["+click_timestamp"] else { return nil }

        if let timeStamp = rawValue as? TimeInterval {
            return timeStamp
        } else if let intValue = rawValue as? Int {
            return TimeInterval(intValue)
        } else if let number = rawValue as? NSNumber {
            return number.doubleValue
        } else {
            print("❌ Invalid timestamp type: \(type(of: rawValue))")
            return nil
        }
    }

}
