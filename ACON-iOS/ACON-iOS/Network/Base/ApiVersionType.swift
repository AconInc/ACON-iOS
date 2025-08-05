//
//  APIVersionType.swift
//  ACON-iOS
//
//  Created by 김유림 on 8/5/25.
//

import Foundation

enum ApiVersionType: String {

    case v1
    case v2

    var utilPath: String {
        return "api/\(self.rawValue)/"
    }

}
