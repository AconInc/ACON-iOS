//
//  SheetUtils.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/13/25.
//

import UIKit

enum ACSheetDetent: String {

    case short
    case middle
    case long
    
    var identifier: UISheetPresentationController.Detent.Identifier {
        return UISheetPresentationController.Detent.Identifier(rawValue)
    }
    
    var height: CGFloat {
        switch self {
        case .short: return 478
        case .middle: return 558
        case .long: return 724
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

extension ACSheetDetent {
    
    static var shortDetent: UISheetPresentationController.Detent {
        return short.detent
    }
    
    static var middleDetent: UISheetPresentationController.Detent {
        return middle.detent
    }
    
    static var longDetent: UISheetPresentationController.Detent {
        return long.detent
    }
    
}
