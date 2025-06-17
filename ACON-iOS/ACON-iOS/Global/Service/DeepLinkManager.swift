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
        let spotID = deepLinkParams?["spotId"] as? Int64
        return spotID
    }

    func presentSpotDetail() {
        if let spotID = getSpotID() {
            DispatchQueue.main.async {
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    let spotDetailVC = SpotDetailViewController(spotID)
                    spotDetailVC.modalPresentationStyle = .fullScreen
                    sceneDelegate.window?.rootViewController?.present(spotDetailVC, animated: true)
                }
            }
        }
    }

}
