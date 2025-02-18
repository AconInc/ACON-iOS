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
    case postReview(_ requestBody: PostReviewRequest)
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
            return utilPath + "reviews"
        case .getSearchKeyword:
            return utilPath + "spots/search"
        case .getReviewVerification:
            return utilPath + "spots/verify"
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
        switch self {
        case .postReview(let requestBody):
            return .requestJSONEncodable(requestBody)
        default:
            if let parameter = parameter {
                return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
            } else {
                return .requestPlain
            }
        }
    }
    
    var headers: [String : String]? {
        var headers = HeaderType.noHeader
        switch self {
        case .getSearchKeyword, .getReviewVerification:
            headers = HeaderType.noHeader
        case .getSearchSuggestion, .postReview, .getAcornCount:
            headers = HeaderType.headerWithToken()
        }
        return headers
    }
    
}
