//
//  AppVersionManager.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/13/25.
//

import UIKit

class AppVersionManager {
    
    static let shared = AppVersionManager()
    
    private let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    private init() { }
    
    private let appStoreURLString = "itms-apps://itunes.apple.com/app/apple-store/6740120473"
    
    private let lookUpURLString = "https://itunes.apple.com/lookup?id=6740120473"
    
    func getAppStoreVersion() async -> String? {
        guard let url = URL(string: lookUpURLString) else { return nil }
            
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  results.count > 0,
                  let appStoreVersion = results[0]["version"] as? String else {
                return nil
            }
            return appStoreVersion
        } catch {
            return nil
        }
    }
    
    func openAppStore() {
        guard let url = URL(string: appStoreURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func checkUpdateAvailable() async -> Bool {
        guard let currentVersion = currentVersion,
              let appStoreVersion = await getAppStoreVersion() else {
            return false
        }

        return currentVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending
    }
    
}



// MARK: - 강제 업데이트 로직

extension AppVersionManager {
    
    func getAppUpdate() async -> Bool {
        guard let currentVersion = currentVersion else { return false }
        
        return await withCheckedContinuation { continuation in
            ACService.shared.appService.getAppUpdate(parameter: GetAppUpdateRequest(version: currentVersion)) { response in
                switch response {
                case .success(let data):
                    continuation.resume(returning: data.forceUpdateRequired)
                default:
                    continuation.resume(returning: false)
                }
            }
        }
    }
    
}
