//
//  BaseView.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/7/25.
//

import UIKit

import SnapKit
import Then

class BaseView: UIView {

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setHierarchy()
        setLayout()
        setStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setHierarchy() {}

    func setLayout() {}
    
    func setStyle() {
        self.backgroundColor = .white
    }

}
