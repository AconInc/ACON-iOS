//
//  UploadTargetType.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/21/25.
//

import Foundation

import Moya

enum UploadTargetType {
    
    case getSearchSuggestion(_ parameter: GetSearchSuggestionRequest)
    case postReview
    case getSearchKeyword(_ parameter: GetSearchKeywordRequest)
    case getReviewVerification(_ parameter: GetReviewVerificationRequest)
    case getAcornCount
    
}

extension UploadTargetType: TargetType {

    var method: Moya.Method {
        switch self {
        case .postReview:
            return .post
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getSearchSuggestion:
            return utilPath + "search-suggestions"
        case .postReview:
            return utilPath + "review"
        case .getSearchKeyword:
            return utilPath + "spots/search"
        case .getReviewVerification:
            return utilPath + "spot/verify"
        case .getAcornCount:
            return utilPath + "member/acorn"
        }
    }
    
    var parameter: [String : Any]?  {
        switch self {
        case .getSearchSuggestion(let parameter):
            return ["latitude": parameter.latitude, "longitude": parameter.longitude]
        case .getSearchKeyword(let parameter):
            return ["keyword": parameter.keyword]
        case .getReviewVerification(let parameter):
            return ["spotId": parameter.spotId,
                    "latitude": parameter.latitude,
                    "longitude": parameter.longitude]
        default:
            return .none
        }
    }
    
    var task: Task {
        if let parameter = parameter {
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
        } else {
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        var headers = HeaderType.noHeader
        switch self {
        case .getSearchKeyword, .getReviewVerification:
            headers = HeaderType.noHeader
        case .getSearchSuggestion:
            headers = HeaderType.basicHeader
        case .postReview, .getAcornCount:
            // TODO: - 추후 유저디폴트 토큰으로 변경
            let token = ""
            headers = HeaderType.headerWithToken(token: "Bearer " + token)
        }
        return headers
    }
    
}
