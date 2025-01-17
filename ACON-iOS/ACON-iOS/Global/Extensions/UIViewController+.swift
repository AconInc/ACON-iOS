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
    
    
    // MARK: - 아이폰 기본 확인 Alert 띄우기
    
    func showDefaultAlert(title: String, message: String, okText: String = StringLiterals.Alert.ok) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // TODO: - 추후 배경색 및 폰트색도 변경
//        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .org0
        let okAction = UIAlertAction(title: okText, style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
    
    func setMiddleSheetLayout() {
       self.modalPresentationStyle = .pageSheet

       if let sheet = self.sheetPresentationController {
           let sheetUtils = SheetUtils()
           sheet.detents = [sheetUtils.acMiddleDetent]
           sheet.prefersScrollingExpandsWhenScrolledToEdge = false
           sheet.prefersGrabberVisible = false

           sheet.selectedDetentIdentifier = sheetUtils.middleDetentIdentifier
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
    
    
    //MARK: - Blur View Add & Remove
    
    func addBlurView(){
        UIView.animate(withDuration: 1.0, animations: {
            let viewBlurEffect = UIVisualEffectView()
            viewBlurEffect.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
            
            self.view.addSubview(viewBlurEffect)
            viewBlurEffect.frame = self.view.bounds
            viewBlurEffect.tag = 200
        })
    }
    
    func removeBlurView() {
        UIView.animate(withDuration: 1.0) {
            if let blurView = self.view.viewWithTag(200) {
                blurView.removeFromSuperview()
            }
        }
    }
    
}
