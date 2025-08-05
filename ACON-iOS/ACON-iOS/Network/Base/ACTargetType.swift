//
//  ApiVersionProtocol.swift
//  ACON-iOS
//
//  Created by 김유림 on 8/5/25.
//

import Foundation

import Moya

// MARK: - Protocol

protocol ACTargetType: TargetType {

    var apiVersion: ApiVersionType { get }

}


// MARK: - Extension

extension ACTargetType {

    var baseURL: URL {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.baseURL) as? String,
              let url = URL(string: urlString) else {
            fatalError("💢💢 BASE_URL이 없음 💢💢")
        }
        return url
    }

    /// API 버전 기본값 (.v1). 필요 시 각 TargetType에서 오버라이드하여 변경 가능.
    var apiVersion: ApiVersionType {
        return .v1
    }

    var utilPath: String {
        return apiVersion.utilPath
    }

}
