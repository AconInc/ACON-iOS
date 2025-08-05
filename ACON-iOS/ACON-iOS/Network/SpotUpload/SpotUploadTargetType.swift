//
//  SpotUploadTargetType.swift
//  ACON-iOS
//
//  Created by 김유림 on 8/5/25.
//

import Foundation

import Moya

enum SpotUploadTargetType {

    case postSpotUpload(_ requestBody: PostSpotUploadRequest)

}

extension SpotUploadTargetType: TargetType {

    var method: Moya.Method {
        switch self {
        case .postSpotUpload:
            return .post
        }
    }

    var path: String {
        switch self {
        case .postSpotUpload:
            return utilPath + "spots/apply"
        }
    }

    var task: Task {
        switch self {
        case .postSpotUpload(let requestBody):
            return .requestJSONEncodable(requestBody)
        }
    }

    var headers: [String : String]? {
        var headers = HeaderType.noHeader
        switch self {
        case .postSpotUpload:
            headers = HeaderType.headerWithToken()
        }
        return headers
    }

}
