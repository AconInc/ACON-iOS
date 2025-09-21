//
//  ImageTargetType.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/17/25.
//

import Foundation

import Moya

enum ImageTargetType {
    
    case postPresignedURL(_ parameter: PostPresignedURLRequest)
    
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
        case .postPresignedURL:
            return .post
        case .putImageToPresignedURL:
            return .put
        }
    }

    var path: String {
        switch self {
        case .postPresignedURL:
            return utilPath + "images/presigned-url"
        case .putImageToPresignedURL:
            return ""
        }
    }
    
    var task: Task {
        switch self {
        case .postPresignedURL(let parameter):
            return .requestJSONEncodable(parameter)
        case .putImageToPresignedURL(let requestBody):
            return .requestData(requestBody.imageData)
        }
    }

    var headers: [String : String]? {
        switch self {
        case .postPresignedURL:
            return HeaderType.basicHeader
        case .putImageToPresignedURL(let requestBody):
            return HeaderType.imageHeader(imageData: requestBody.imageData)
        }
    }

}
