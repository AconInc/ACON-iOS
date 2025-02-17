//
//  ImageTargetType.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/17/25.
//

import Foundation

import Moya

enum ImageTargetType {
    
    case getPresignedURL(_ parameter: GetPresignedURLRequest)

}

extension ImageTargetType: TargetType {

    var method: Moya.Method {
        switch self {
        case .getPresignedURL:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getPresignedURL:
            return utilPath + "images/presigned-url"
        }
    }
    
    var task: Task {
        switch self {
        case .getPresignedURL(let parameter):
            return .requestParameters(
                parameters: ["imageType": parameter.imageType],
                encoding: URLEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        switch self {
        case .getPresignedURL:
            return HeaderType.noHeader
        }
    }

}
