//
//  LocalVerificationErrorType.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/12/25.
//

import Foundation

enum PostLocalAreaErrorType {
    
    case unsupportedRegion, outOfRange
    
}

enum DeleteVerifiedAreaErrorType {

    case unsupportedRegion, timeOut, onlyOne
    
}

enum PostReplaceVerifiedAreaErrorType {

    case unsupportedRegion, notValid, timeOut, notUniqueVerifiedArea
    
}
