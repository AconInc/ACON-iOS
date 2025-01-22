//
//  SheetUtils.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/13/25.
//

import UIKit

struct SheetUtils {
    
    let shortDetentIdentifier = UISheetPresentationController.Detent.Identifier(StringLiterals.SheetUtils.shortDetent)
    let middleDetentIdentifier = UISheetPresentationController.Detent.Identifier(StringLiterals.SheetUtils.middleDetent)
    let longDetentIdentifier = UISheetPresentationController.Detent.Identifier(StringLiterals.SheetUtils.longDetent)
    
    var acShortDetent: UISheetPresentationController.Detent {
        return UISheetPresentationController.Detent.custom(identifier: shortDetentIdentifier) { _ in
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let safeAreaBottom = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
            return ScreenUtils.heightRatio*478 - safeAreaBottom
        }
    }
    
    var acMiddleDetent: UISheetPresentationController.Detent {
         return UISheetPresentationController.Detent.custom(identifier: longDetentIdentifier) { _ in
             let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
             let safeAreaBottom = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
             return ScreenUtils.heightRatio*558 - safeAreaBottom
         }
     }
    
    var acLongDetent: UISheetPresentationController.Detent {
        return UISheetPresentationController.Detent.custom(identifier: longDetentIdentifier) { _ in
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let safeAreaBottom = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
            return ScreenUtils.heightRatio*724 - safeAreaBottom
        }
    }
    
}
