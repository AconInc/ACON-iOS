//
//  TargetType+.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/20/25.
//

import Foundation

import Moya

extension TargetType {

    var baseURL: URL {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.baseURL) as? String,
              let url = URL(string: urlString) else {
            fatalError("💢💢 BASE_URL이 없음 💢💢")
        }
        return url
    }

    /// NOTE: 기본 API 버전 (필요 시 개별 Target에서 오버라이드)
    var apiVersion: ApiVersionType {
        return .v1
    }

    var utilPath: String {
        return apiVersion.utilPath
    }

}
