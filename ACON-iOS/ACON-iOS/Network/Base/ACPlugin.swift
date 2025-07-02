//
//  ACPlugin.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/19/25.
//

import Foundation

import Moya

final class ACPlugin: PluginType {
    
    // MARK: - Request 보낼 시 호출
    
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            print("--> 유효하지 않은 요청")
            return
        }
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "메소드값이 nil입니다."
        var log = "----------------------------------------------------\n1️⃣[\(method)] \(url)\n----------------------------------------------------\n"
        log.append("2️⃣API: \(target)\n")
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            log.append("header: \(headers)\n")
        }
        if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            log.append("\(bodyString)\n")
        }
        log.append("------------------- END \(method) -------------------")
        print(log)
    }
    
    
    // MARK: - Response 받을 시 호출
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            self.onSucceed(response, target: target)
        case let .failure(error):
            self.onFail(error, target: target)
        }
    }
    
    func onSucceed(_ response: Response, target: TargetType) {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        var log = "----------------🐿️ Reponse 도착함 ㅋㅋ 🐿️-------------------"
        log.append("\n3️⃣[\(statusCode)] \(url)\n")
        log.append("API: \(target)\n")
        log.append("Status Code: [\(statusCode)]\n")
        log.append("URL: \(url)\n")
        log.append("response: \n")
        if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
            log.append("4️⃣\(reString)\n")
        }
        log.append("------------------- END HTTP -------------------")
        print(log)
    }
    
    func onFail(_ error: MoyaError, target: TargetType) {
        if let response = error.response {
            onSucceed(response, target: target)
            return
        }
        var log = "😤😤😤 네트워크 오류 😤😤😤"
        log.append("<-- \(error.errorCode)\n")
        log.append("\(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
        log.append("<-- END HTTP")
        print(log)
    }
    
}
