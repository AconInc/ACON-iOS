//
//  NetworkResult.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/19/25.
//

import Foundation

enum NetworkResult<T> {
    
    case success(T)  // 성공
    case requestErr(T)  // 요청 에러
    case decodedErr  // 디코딩 에러
    case pathErr     // 경로 에러
    case serverErr   // 서버 내부 오류
    case networkFail // 네트워크 연결 실패 -> 네트워크 확인
    case reIssueJWT // 토큰 재이슈 필요
    
    func statusCodeDescription() {
        switch self {
        case .success:
            print("Status Code Description: 성공 ㅋㅋ")
        case .requestErr:
            print("Status Code Description: 요청 에러")
        case .decodedErr:
            print("Status Code Description: 디코딩 에러")
        case .pathErr:
            print("Status Code Description: 경로 에러")
        case .serverErr:
            print("Status Code Description: 서버 내부 에러")
        case .networkFail:
            print("Status Code Description: 네트워크 연결 실패 - 와이파이 확인하셈")
        case .reIssueJWT:
            print("Status Code Description: 토큰 재발급 필요")
        }
    }

}
