//
//  Bundle+.swift
//  ACON-iOS
//
//  Created by 김유림 on 6/20/25.
//

import Foundation

extension Bundle {

    var isTestFlight: Bool {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL {
            return appStoreReceiptURL.lastPathComponent == "sandboxReceipt"
        }
        return false
    }

}
