//
//  UIViewController+.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/6/25.
//

import UIKit

extension UIViewController {
    
    // MARK: - 키보드 외 부분 터치 시 키보드 내려감
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: - 바텀시트 내려가게
    
    func setShortSheetLayout() {
        self.modalPresentationStyle = .pageSheet
        
        if let sheet = self.sheetPresentationController {
            let sheetUtils = SheetUtils()
            sheet.detents = [sheetUtils.acShortDetent]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = false
            
            sheet.selectedDetentIdentifier = sheetUtils.shortDetentIdentifier
        }
    }
    
    func setLongSheetLayout() {
        self.modalPresentationStyle = .pageSheet
        
        if let sheet = self.sheetPresentationController {
            let sheetUtils = SheetUtils()
            sheet.detents = [sheetUtils.acLongDetent]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = false
            
            sheet.selectedDetentIdentifier = sheetUtils.longDetentIdentifier
        }
    }
    
}
