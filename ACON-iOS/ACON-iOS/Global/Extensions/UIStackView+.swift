//
//  UIStackView+.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/6/25.
//

import UIKit

extension UIStackView {
    
    // MARK: - UIView 여러 개 한 번에 addArrangedSubview
    
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
    
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { subview in
            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
    
}
