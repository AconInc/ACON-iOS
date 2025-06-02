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
    
    
    //MARK: - add GlassBorder (주의 - bound가 0이면 적용 안 됨)
    
    func addGlassBorder(_ attributes: GlassBorderAttributes) {
        self.layer.borderWidth = 0
        
        let outerPath = UIBezierPath(roundedRect: bounds, cornerRadius: attributes.cornerRadius)
        let innerRect = bounds.insetBy(dx: attributes.width, dy: attributes.width)
        let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: max(0, attributes.cornerRadius - attributes.width/2))
        outerPath.append(innerPath.reversing())
        
        let glassBorderView = GlassmorphismView(attributes.glassmorphismType)
        glassBorderView.tag = 250603
        
        self.addSubview(glassBorderView)
        glassBorderView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = outerPath.cgPath
        maskLayer.fillRule = .evenOdd
        
        let maskView = UIView(frame: bounds)
        maskView.layer.addSublayer(maskLayer)
        glassBorderView.mask = maskView
    }
    
    func removeGlassBorder() {
        self.viewWithTag(250603)?.removeFromSuperview()
    }

}
