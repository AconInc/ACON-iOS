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
    
    func showDefaultAlert(title: String,
                          message: String,
                          okText: String = StringLiterals.Alert.ok,
                          isCancelAvailable: Bool = false,
                          cancelText: String = "취소",
                          completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // TODO: - 추후 배경색 및 폰트색도 변경
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .gray800
        let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.acWhite]
        let messageAttributes = [NSAttributedString.Key.foregroundColor: UIColor.acWhite]
        
        let titleString = NSAttributedString(string: title, attributes: titleAttributes)
        let messageString = NSAttributedString(string: message, attributes: messageAttributes)
        
        alert.setValue(titleString, forKey: "attributedTitle")
        alert.setValue(messageString, forKey: "attributedMessage")
            
        
        let okAction = UIAlertAction(title: okText, style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        okAction.setValue(UIColor.primaryLight, forKey: "titleTextColor")
        
        if isCancelAvailable {
            let cancelAction = UIAlertAction(title: cancelText, style: .cancel)
            alert.addAction(cancelAction)
            cancelAction.setValue(UIColor.gray500, forKey: "titleTextColor")
        }
        
        present(alert, animated: true)
    }
    
    
    // MARK: - 바텀시트 내려가게
    
    func setSheetLayout(detent: ACSheetDetentType) {
        self.modalPresentationStyle = .pageSheet
        
        if let sheet = self.sheetPresentationController {
            sheet.detents = [detent.detent]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = false
            sheet.selectedDetentIdentifier = detent.identifier
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
    
    
    // MARK: - 로그인 안 했으면 모달시트 띄우기
    
    func presentLoginModal(_ presentedModalType: String) {
        let vc = LoginModalViewController(presentedModalType)
        vc.setSheetLayout(detent: .middle)
        
        self.present(vc, animated: true)
    }
    
}
