//
//  BuildConfig.swift
//  ACON-iOS
//
//  Created by 김유림 on 10/14/25.
//

import Foundation

enum BuildConfig {

    #if DEBUG
    static let isDebug = true
    #else
    static let isDebug = false
    #endif

}
