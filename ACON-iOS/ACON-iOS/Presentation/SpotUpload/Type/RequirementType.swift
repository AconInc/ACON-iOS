//
//  RequirementType.swift
//  ACON-iOS
//
//  Created by 김유림 on 7/16/25.
//

import UIKit

enum RequirementType {

    case required

    case optional

    var text: String {
        switch self {
        case .required: return StringLiterals.SpotUpload.required
        case .optional: return StringLiterals.SpotUpload.optional
        }
    }
    
    var color: UIColor {
        switch self {
        case .required: return .labelDanger
        case .optional: return .gray300
        }
    }

}
