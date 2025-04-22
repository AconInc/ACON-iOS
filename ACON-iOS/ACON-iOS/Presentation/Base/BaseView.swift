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

    private let handlerImageView: UIImageView = UIImageView()
    
    
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
        self.backgroundColor = .gray900
    }

}

// MARK: setHandlerImage for Modal

extension BaseView {

    func setHandlerImageView() {
        self.addSubview(handlerImageView)

        handlerImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.heightRatio*4)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.heightRatio*36)
            $0.height.equalTo(ScreenUtils.heightRatio*5)
        }

        handlerImageView.do {
            $0.image = .btnBottomsheetBar
            $0.contentMode = .scaleAspectFit
        }
    }

}
