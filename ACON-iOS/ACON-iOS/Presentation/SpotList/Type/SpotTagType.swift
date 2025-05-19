//
//  SpotTagType.swift
//  ACON-iOS
//
//  Created by 김유림 on 5/3/25.
//

import Foundation

enum SpotTagType: Equatable {
    case new
    case local
    case top(number: Int)
    case unknown(raw: String)

    init(rawValue: String) {
        switch rawValue {
        case "NEW":
            self = .new
        case "LOCAL":
            self = .local
        default:
            if rawValue.starts(with: "TOP ") {
                let suffix = rawValue.dropFirst(4)
                if let number = Int(suffix) {
                    self = .top(number: number)
                    return
                }
            }
            self = .unknown(raw: rawValue)
        }
    }

    var rawValue: String {
        switch self {
        case .new:
            return "NEW"
        case .local:
            return "LOCAL"
        case .top(let number):
            return "TOP \(number)"
        case .unknown(let raw):
            return raw
        }
    }
}
