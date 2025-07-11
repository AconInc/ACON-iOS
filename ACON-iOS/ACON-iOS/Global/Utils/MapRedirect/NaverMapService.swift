//
//  NaverMapService.swift
//  ACON-iOS
//
//  Created by 김유림 on 6/6/25.
//

import UIKit

final class NaverMapService: MapServiceProtocol {

    private let naverMapAppStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id311867728?mt=8")

    func openMap(from startPoint: MapRedirectModel,
                 to destination: MapRedirectModel,
                 transportMode: TransportModeType) {
        do {
            let url = try buildNaverMapURL(from: startPoint, to: destination, transportMode: transportMode)
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                openAppStore()
            }
        } catch {
            handleError(error)
        }
    }

    private func buildNaverMapURL(from startPoint: MapRedirectModel,
                                  to destination: MapRedirectModel,
                                  transportMode: TransportModeType) throws -> URL {
        guard let appName = Bundle.main.bundleIdentifier else {
            throw MapServiceError.bundleIdentifierFailed
        }

        let urlString = "nmap://route/\(transportMode.naverMapKey)?slat=\(startPoint.latitude)&slng=\(startPoint.longitude)&sname=\(startPoint.name)&dlat=\(destination.latitude)&dlng=\(destination.longitude)&dname=\(destination.name)&appname=\(appName)"
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedString) else {
            throw MapServiceError.invalidURL
        }

        return url
    }

    private func openAppStore() {
        guard let appStoreURL = naverMapAppStoreURL else { return }
        UIApplication.shared.open(appStoreURL)
    }

    private func handleError(_ error: Error) {
        print("❌ Naver Map Error: \(error)")
    }

}
