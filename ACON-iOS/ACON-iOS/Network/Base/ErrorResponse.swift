//
//  ErrorResponse.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/19/25.
//

import Foundation

// MARK: - 공통 예외 처리 Response

struct ErrorResponse: Decodable {
    
    let code: Int
    let message: String
    let errors: [ErrorDetail]?
    
}

struct ErrorDetail: Decodable {
    
    let path: String?
    let field: String?
    let message: String
    
}
