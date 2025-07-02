//
//  GoogleAdsErrorType.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/5/25.
//

import UIKit

import GoogleMobileAds

enum GoogleAdsErrorType {
    
    case networkError
    
    case noAdToShow
    
    case managerError(GoogleAdsManagerError)
    
    case unknownError(String)
    
    init(from error: Error) {
        let nsError = error as NSError
        
        switch nsError.domain {
        case NSURLErrorDomain:
            // NOTE: - 네트워크 에러
            if nsError.code == NSURLErrorNotConnectedToInternet {
                self = .networkError
            } else {
                self = .unknownError("Network: \(nsError.localizedDescription)")
            }
            
        case "com.google.admob":
            // NOTE: - 구글 애드몹 에러 (구글에서 내려주는 에러)
            switch nsError.code {
            case 1:
                self = .noAdToShow
            case 2:
                self = .networkError
            default:
                self = .unknownError("AdMob(\(nsError.code)): \(nsError.localizedDescription)")
            }
        
        case "GoogleAdsManager":
            // NOTE: - GoogleAdsManager 에러 (자체 에러)
            switch nsError.code {
            case 1:
                self = .managerError(.alreadyLoading)
            case 2:
                self = .managerError(.noWindowScene)
            default:
                self = .unknownError("Manager(\(nsError.code)): \(nsError.localizedDescription)")
            }
            
        default:
            self = .unknownError("Unknown(\(nsError.domain)): \(nsError.localizedDescription)")
        }
    }
    
    var description: String {
        switch self {
        case .networkError:
            return "네트워크 에러"
        case .noAdToShow:
            return "표시할 광고 없음 (제한 다 씀)"
        case .managerError(let managerError):
            return managerError.description
        case .unknownError(let message):
            return "unknownError - \(message)"
        }
    }
    
}


// MARK: - GoogleAdsManagerErr

enum GoogleAdsManagerError: Error {
    
    case alreadyLoading // NOTE: - 이미 광고 로드 중
    case noWindowScene  // NORE: - Window Scene 없음
    
    var nsError: NSError {
        switch self {
        case .alreadyLoading:
            return NSError(domain: "GoogleAdsManager", code: 1,
                         userInfo: [NSLocalizedDescriptionKey: "Already loading"])
        case .noWindowScene:
            return NSError(domain: "GoogleAdsManager", code: 2,
                         userInfo: [NSLocalizedDescriptionKey: "No active window scene found"])
        }
    }
    
    var description: String {
        switch self {
        case .alreadyLoading:
            return "로드 중"
        case .noWindowScene:
            return "Window Scene 없음"
        }
    }
    
}
