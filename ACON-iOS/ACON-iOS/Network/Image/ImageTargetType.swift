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
    
    case putImageToPresignedURL(_ requestBody: PutImageToPresignedURLRequest)

}

extension ImageTargetType: ACTargetType {

    var baseURL: URL {
        switch self {
        case .putImageToPresignedURL(let request):
            if let url = URL(string: request.presignedURL) {
                return url
            }
        default:
            guard let urlString = Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.baseURL) as? String,
                  let url = URL(string: urlString) else {
                fatalError("💢💢 BASE_URL이 없음 💢💢")
            }
            return url
        }
        fatalError("Invalid URL")
    }
    
    var method: Moya.Method {
        switch self {
        case .getPresignedURL:
            return .get
        case .putImageToPresignedURL:
            return .put
        }
    }

    var path: String {
        switch self {
        case .getPresignedURL:
            return utilPath + "images/presigned-url"
        case .putImageToPresignedURL:
            return ""
        }
    }
    
    var task: Task {
        switch self {
        case .getPresignedURL(let parameter):
            return .requestParameters(
                parameters: ["imageType": parameter.imageType],
                encoding: URLEncoding.default
            )
        case .putImageToPresignedURL(let requestBody):
            return .requestData(requestBody.imageData)
        }
    }

    var headers: [String : String]? {
        switch self {
        case .getPresignedURL:
            return HeaderType.noHeader
        case .putImageToPresignedURL(let requestBody):
            return HeaderType.imageHeader(imageData: requestBody.imageData)
        }
    }

}
