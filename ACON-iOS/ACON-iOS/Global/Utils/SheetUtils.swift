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
            return ScreenUtils.height*478/780 - safeAreaBottom
        }
    }
    
    var acMiddleDetent: UISheetPresentationController.Detent {
         return UISheetPresentationController.Detent.custom(identifier: longDetentIdentifier) { _ in
             let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
             let safeAreaBottom = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
             return ScreenUtils.height*558/780 - safeAreaBottom
         }
     }
    
    var acLongDetent: UISheetPresentationController.Detent {
        return UISheetPresentationController.Detent.custom(identifier: longDetentIdentifier) { _ in
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let safeAreaBottom = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
            return ScreenUtils.height*700/780 - safeAreaBottom
        }
    }
    
}
