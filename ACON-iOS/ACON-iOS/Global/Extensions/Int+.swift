//
//  Int+.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/16/25.
//

import Foundation

extension Int {
    
    var formattedWithSeparator: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }

}
