//
//  ACSheetDetentType.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/13/25.
//

import UIKit

enum ACSheetDetentType: String {

    case short
    case semiShort
    case middle
    case long

    var identifier: UISheetPresentationController.Detent.Identifier {
        return UISheetPresentationController.Detent.Identifier(rawValue)
    }

    var height: CGFloat {
        switch self {
        case .short: return 204
        case .semiShort: return 300
        case .middle: return 518
        case .long: return 680
        }
    }

    var detent: UISheetPresentationController.Detent {
        return UISheetPresentationController.Detent.custom(identifier: identifier) { _ in
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let safeAreaBottom = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
            return ScreenUtils.heightRatio * height - safeAreaBottom
        }
    }

}

extension ACSheetDetentType {

    static var shortDetent: UISheetPresentationController.Detent {
        return short.detent
    }

    static var semiShortDetent: UISheetPresentationController.Detent {
        return semiShort.detent
    }
    
    static var middleDetent: UISheetPresentationController.Detent {
        return middle.detent
    }

    static var longDetent: UISheetPresentationController.Detent {
        return long.detent
    }

}
