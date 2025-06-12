//
//  UIView+.swift
//  ACON-iOS
//
//  Created by 이수민 on 1/6/25.
//

import UIKit

import SkeletonView

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


//MARK: - GlassBorder 설정

extension UIView {

    private struct AssociatedKeys {
        static var glassBorderView: UInt8 = 0
    }

    private var glassBorderView: GlassmorphismView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.glassBorderView) as? GlassmorphismView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.glassBorderView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 주의: bounds가 0이면 적용 안 됨
    func addGlassBorder(_ attributes: GlassBorderAttributes) {
        self.layer.borderWidth = 0

        glassBorderView?.removeFromSuperview()
        
        let outerPath = UIBezierPath(roundedRect: bounds, cornerRadius: attributes.cornerRadius)
        let innerRect = bounds.insetBy(dx: attributes.width, dy: attributes.width)
        let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: max(0, attributes.cornerRadius - attributes.width/2))
        outerPath.append(innerPath.reversing())

        let newGlassBorderView = GlassmorphismView(attributes.glassmorphismType)
        self.glassBorderView = newGlassBorderView

        self.addSubview(newGlassBorderView)

        newGlassBorderView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        let maskLayer = CAShapeLayer()
        maskLayer.path = outerPath.cgPath
        maskLayer.fillRule = .evenOdd

        let maskView = UIView(frame: bounds)
        maskView.layer.addSublayer(maskLayer)
        newGlassBorderView.mask = maskView

        newGlassBorderView.isUserInteractionEnabled = false
    }

    func refreshGlassBorder() {
        glassBorderView?.refreshBlurEffect()
    }

    func removeGlassBorder() {
        glassBorderView?.removeFromSuperview()
    }
    
    
    // MARK: - Set Gradient
        
    func setGradient(topColor: UIColor = .gray900.withAlphaComponent(1),
                     bottomColor: UIColor = .gray900.withAlphaComponent(0.1),
                     startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
                     endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)) {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer()
        }
        
        let gradient = CAGradientLayer()
        gradient.do {
            $0.frame = bounds
            $0.colors = [topColor.cgColor, bottomColor.cgColor]
            $0.startPoint = startPoint
            $0.endPoint = endPoint
        }
//        layer.insertSublayer(gradient, at: 0)
        layer.addSublayer(gradient)
        // TODO: - 그라 밑 글모? 글모 밑 그라? -> 디자인에게 물어보기
        // blurEffectView.contentView.layer.insertSublayer(gradient, at: 0)
    }

    func setTripleGradient(topColor: UIColor = .acBlack.withAlphaComponent(0.6),
                           middleColor: UIColor = .gray300.withAlphaComponent(0.5),
                           bottomColor: UIColor = .acBlack.withAlphaComponent(0.6),
                           locations: [NSNumber]? = [0.0, 0.5, 1.0],
                           startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
                           endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)) {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        let gradient = CAGradientLayer()
        gradient.do {
            $0.frame = bounds
            $0.colors = [topColor.cgColor, middleColor.cgColor, bottomColor.cgColor]
            $0.locations = locations
            $0.startPoint = startPoint
            $0.endPoint = endPoint
        }
        layer.addSublayer(gradient)
    }

    func removeGradient() {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
    }

}


// MARK: - Skeleton 설정

extension UIView {

    func startACSkeletonAnimation(direction: GradientDirection = .topLeftBottomRight,
                                  duration: CFTimeInterval = 1.5,
                                  autoreverses: Bool = true) {
        let diagonalAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: direction, duration: duration, autoreverses: autoreverses)
        
        self.showAnimatedGradientSkeleton(
            usingGradient: .init(colors: [.acWhite.withAlphaComponent(0.3),
                                          .acWhite.withAlphaComponent(0.1)]),
            animation: diagonalAnimation
        )
    }

}
