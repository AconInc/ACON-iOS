//
//  UIView+.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/6/25.
//

import UIKit

extension UIView {

    // MARK: - UIView 여러 개 한 번에 addSubview

    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }


    // MARK: - 뷰 모서리 둥글게

    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }


    // MARK: - 바텀시트 핸들 이미지 추가

    func setHandlerImageView() {
        let handlerImageView: UIImageView = UIImageView()
        self.addSubview(handlerImageView)

        handlerImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14 * ScreenUtils.heightRatio)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(36 * ScreenUtils.widthRatio)
            $0.height.equalTo(5 * ScreenUtils.heightRatio)
        }

        handlerImageView.do {
            $0.image = .btnBottomsheetBar
            $0.contentMode = .scaleAspectFit
        }
    }

}
