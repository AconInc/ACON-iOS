//
//  AppVersionManager.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/13/25.
//

import Foundation

class AppVersionManager {
    
    // MARK: - 버전 체크 로직
    // TODO: - 추후 더 나은 방식의 비동기처리로 리팩
//    static func checkVersion(completion: @escaping (Bool) -> Void) {
//        getUpdatedVersion { updatedVersion in
//            guard let dictionary = Bundle.main.infoDictionary,
//                  let currentVersion = dictionary["CFBundleShortVersionString"] as? String else {
//                completion(false)
//                return
//            }
//            completion(updatedVersion == currentVersion)
//        }
//    }
    
//    static func getUpdatedVersion(completion: @escaping (String) -> Void) {
//        guard let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(Bundle.main.bundleIdentifier ?? "")") else {
//            completion("")
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data,
//                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
//                  let results = json["results"] as? [[String: Any]],
//                  results.count > 0,
//                  let appStoreVersion = results[0]["version"] as? String else {
//                completion("")
//                return
//            }
//            completion(appStoreVersion)
//        }.resume()
//    }
    
}
