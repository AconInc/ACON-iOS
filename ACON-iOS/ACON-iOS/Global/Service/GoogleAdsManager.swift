//
//  GoogleAdsManager.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/4/25.
//

import Foundation

import GoogleMobileAds
import Network

final class GoogleAdsManager: NSObject {
    
    // MARK: - Properties
    
    static let shared = GoogleAdsManager()
    
    private var adLoader: AdLoader?
    
    private var cachedAd: [GoogleAdsType: NativeAd] = [:]
    
    private var loadCompletion: ((NativeAd?, Error?) -> Void)?
    
    private var isLoading = false
    
    private var isNetworkConnected = false
    
    var needsAdReloadOnNetworkRecovery = false
    
    private var periodicNetworkCheckTimer: Timer?
    

    // MARK: - Internal Methods
    
    func initialize() {
        MobileAds.shared.start(completionHandler: nil)
        
        periodicNetworkCheck()
        preloadNativeAd(.imageOnly)
        preloadNativeAd(.both)
    }
    
    func getNativeAd(_ adType: GoogleAdsType) -> NativeAd? {
        guard let ad = cachedAd[adType] else {
            print("🥐 캐시된 광고 없음 - 즉시 로드 시작")
            if !isLoading {
                preloadNativeAd(adType)
            }
            return nil
        }
        
        cachedAd[adType] = nil
        print("🥐 캐시된 광고 반환 - 다음 광고 로드 시작")
        preloadNativeAd(adType)
        return ad
    }
    
    func preloadNativeAd(_ adType: GoogleAdsType) {
        guard cachedAd[adType] == nil && !isLoading else { return }

        self.loadNativeAd(adType) { [weak self] ad, error in
            if let ad = ad {
                self?.cachedAd[adType] = ad
            } else {
                self?.handleAdLoadError(error)
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    private func loadNativeAd(_ adType: GoogleAdsType,
                              completion: @escaping ((NativeAd?, Error?) -> Void)) {
        guard !isLoading else {
            completion(nil, GoogleAdsManagerError.alreadyLoading)
            return
        }
        
        isLoading = true
        loadCompletion = completion
        
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                completion(nil, GoogleAdsManagerError.noWindowScene)
                return
            }
            
            DispatchQueue.global().async {
                let adUnitID = adType == .both ? Config.GADAdUnitID : Config.GADAdUnitIDImageOnly
                let request = Request()
                
                let options = NativeAdImageAdLoaderOptions().then {
                    $0.isImageLoadingDisabled = false
                    $0.shouldRequestMultipleImages = false
                }
                
                self.adLoader = AdLoader(
                    adUnitID: adUnitID,
                    rootViewController: rootViewController,
                    adTypes: [.native],
                    options: [options]
                ).then {
                    $0.delegate = self
                }
                
                self.adLoader?.load(request)
            }
        }
    }
    
}


// MARK: - AdLoaderDelegate

extension GoogleAdsManager: NativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        loadCompletion?(nativeAd, nil)
        loadCompletion = nil
        isLoading = false
    }
    
    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        loadCompletion?(nil, error)
        loadCompletion = nil
        isLoading = false
    }
    
}


// MARK: - 네트워크 연결 관련 메소드

extension GoogleAdsManager {
    
    // NOTE: 광고 객체 초기화
    func resetAdState() {
        cachedAd.removeAll()
        isLoading = false
        isNetworkConnected = false
        needsAdReloadOnNetworkRecovery = false
    }
    
    // NOTE: 3초마다 네트워크 확인
    // TODO: - 추후 위치 감지 로직에 사용, 혹은 통합 (주기적 체크)
    func periodicNetworkCheck() {
        periodicNetworkCheckTimer?.invalidate()
        periodicNetworkCheckTimer = nil
        
        periodicNetworkCheckTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            let monitor = NWPathMonitor()
            let checkQueue = DispatchQueue(label: "PeriodicNetworkCheck")
            
            monitor.pathUpdateHandler = { path in
                let isConnected = path.status == .satisfied
                let previousState = self.isNetworkConnected
                self.isNetworkConnected = isConnected
                
                if isConnected && !previousState && self.needsAdReloadOnNetworkRecovery {
                    print("🥐 periodicNetworkCheck - 네트워크 복구 감지")
                    
                    DispatchQueue.main.async {
                        self.needsAdReloadOnNetworkRecovery = false
                        
                        self.resetAdState()
                        self.preloadNativeAd(.imageOnly)
                        self.preloadNativeAd(.both)
                    }
                } else if !isConnected && previousState {
                    print("🥐 periodicNetworkCheck - 네트워크 끊김 감지")
                    self.needsAdReloadOnNetworkRecovery = true
                }
                monitor.cancel()
            }
            monitor.start(queue: checkQueue)
        }
        print("🥐 periodicNetworkCheck - 네트워크 확인 시작")
    }
    
}


// MARK: - 에러 핸들링

extension GoogleAdsManager {
    
    private func handleAdLoadError(_ error: Error?) {
        guard let adError = error else { return }
        
        let adErrorType = GoogleAdsErrorType(from: adError)
        print("🥐 광고 로드 실패: \(adErrorType.description)")

        if case .networkError = adErrorType {
            resetAdState()
            needsAdReloadOnNetworkRecovery = true
            return
        }
    }
    
}
