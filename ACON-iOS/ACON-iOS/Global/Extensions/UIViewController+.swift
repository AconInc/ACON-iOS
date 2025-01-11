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
    
    func showDefaultAlert(title: String, message: String, okText: String = "확인") {
        //  TODO: - 추후 StringLiterals에 확인 넣기
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // TODO: - 추후 배경색 및 폰트색도 변경
//        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .org0
        let okAction = UIAlertAction(title: okText, style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}
