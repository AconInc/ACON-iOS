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
        let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.acWhite]
        let messageAttributes = [NSAttributedString.Key.foregroundColor: UIColor.acWhite, NSAttributedString.Key.font: ACFontType.b1R.fontStyle.font]
        
        let titleString = NSAttributedString(string: title, attributes: titleAttributes)
        let messageString = NSAttributedString(string: message, attributes: messageAttributes)
        
        alert.setValue(titleString, forKey: "attributedTitle")
        alert.setValue(messageString, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: okText, style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        okAction.setValue(UIColor.labelAction, forKey: "titleTextColor")
        
        if isCancelAvailable {
            let cancelAction = UIAlertAction(title: cancelText, style: .cancel)
            alert.addAction(cancelAction)
            cancelAction.setValue(UIColor.acWhite, forKey: "titleTextColor")
        }
        
        present(alert, animated: true)
    }
    
    func showServerErrorAlert(_ action: (() -> Void)? = nil) {
        self.showDefaultAlert(title: "알림",
                              message: "서비스에 연결할 수 없습니다.\n잠시 후 다시 시도해주세요.",
                              completion: action)
    }
    
    func showNeedLoginAlert() {
        self.showDefaultAlert(title: "알림",
                              message: "로그인이 필요한 서비스입니다.") {
            NavigationUtils.navigateToSplash()
        }
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
    
    func presentLoginModal(_ presentedModalType: String?) {
        let vc = LoginModalViewController(presentedModalType)
        vc.setSheetLayout(detent: .middle)
        
        self.present(vc, animated: true)
    }
    
    
    // MARK: - 커스텀 알럿
    
    func presentACAlert(_ customAlertType: ACAlertType,
                            longAction: (() -> Void)? = nil,
                            leftAction: (() -> Void)? = nil,
                            rightAction: (() -> Void)? = nil,
                            from vc: UIViewController? = nil) {
        let alertVC = ACAlertViewController(customAlertType)
        
        alertVC.do {
            $0.onLongButtonTapped = longAction
            $0.onLeftButtonTapped = leftAction
            $0.onRightButtonTapped = rightAction
            
            $0.modalPresentationStyle = .overFullScreen
            $0.modalTransitionStyle = .crossDissolve
        }

        if let vc = vc {
            vc.present(alertVC, animated: true)
        } else {
            self.present(alertVC, animated: true)
        }
    }
    
}
