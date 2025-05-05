//
//  ACButton.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/2/25.
//

import UIKit

struct GlassBorderAttributes {
    
    let width: CGFloat
    
    let cornerRadius: CGFloat
    
    let glassmorphismType: GlassmorphismType
    
    init(width: CGFloat, cornerRadius: CGFloat, glassmorphismType: GlassmorphismType) {
        self.width = width
        self.cornerRadius = cornerRadius
        self.glassmorphismType = glassmorphismType
    }
    
}

class ACButton: UIButton {
    
    // MARK: - UI Properties
    
    private var glassmorphismView: GlassmorphismView?
    
    private var borderLayer: CAShapeLayer?
    
    
    // MARK: - Properties
    
    private var glassBorderAttributes: GlassBorderAttributes?

    
    // MARK: - Lifecycle
    
    init(
        style: ButtonStyleType,
        title: String? = nil,
        image: UIImage? = nil,
        isEnabled: Bool = true
    ) {
        super.init(frame: .zero)
        
        setProperties(style, title, image, isEnabled)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        glassmorphismView?.layer.cornerRadius = self.layer.cornerRadius
        glassmorphismView?.layer.masksToBounds = true
        
        if let attributes = glassBorderAttributes, bounds.width > 0, bounds.height > 0 {
            applyGlassBorder(attributes)
        }
    }
    
}

extension ACButton {
    
    func setProperties(_ style: ButtonStyleType,
                       _ title: String? = nil,
                       _ image: UIImage? = nil,
                       _ isEnabled: Bool) {
        if let style = style as? ConfigButtonStyleType {
            setConfig(style)
        }
        setButtonStyle(style, title, image, isEnabled)
    }
    
    
    // MARK: - Set Button Configuration
    
    func setConfig(_ style: ConfigButtonStyleType) {
        
        var config: UIButton.Configuration
        
        switch style.configStyle {
        case .filled:
            config = .filled()
        case .plain:
            config = .plain()
        @unknown default:
            config = .plain()
        }

        config.imagePlacement = style.imagePlacement
        config.imagePadding = style.imagePadding
        
        config.titleAlignment = style.titleAlignment
        config.contentInsets = style.contentInsets
        
        config.showsActivityIndicator = style.showsActivityIndicator
        
        self.configuration = config
    }
    
    
    // MARK: - Set Button Style
    
    func setButtonStyle(_ style: ButtonStyleType,
                        _ title: String?,
                        _ image: UIImage?,
                        _ isEnabled: Bool) {
        
        self.do {
            $0.backgroundColor = style.backgroundColor
            
            if let glassmorphismType = style.glassmorphismType {
                /// borderWidth > 0 이면 테두리만 글모, 0일 경우 전체 배경 글모
                if style.borderWidth > 0 && style.borderColor == .clear {
                    glassBorderAttributes = GlassBorderAttributes(width: style.borderWidth,
                                                                  cornerRadius: style.cornerRadius,
                                                                  glassmorphismType: glassmorphismType)
                } else {
                    setGlassmorphism(glassmorphismType)
                }
            }
            
            $0.layer.cornerRadius = style.cornerRadius
            $0.isEnabled = isEnabled
            
            if style.borderWidth > 0 {
                $0.layer.borderWidth = style.borderWidth
                $0.layer.borderColor = style.borderColor.cgColor
            }
            
            if let title = title {
                $0.setAttributedTitle(text: title,
                                      style: style.textStyle,
                                      color: style.textColor)
            }
            
            if let image = image {
                $0.setImage(image, for: .normal)
            }
        }
    }
     
    
    // MARK: - Set Glassmorphism
    
    private func setGlassmorphism(_ glassmorphismType: GlassmorphismType) {
        glassmorphismView?.removeFromSuperview()
        self.backgroundColor = .clear
        
        glassmorphismView = GlassmorphismView(glassmorphismType).then {
            self.insertSubview($0, at: 0)
        }

        glassmorphismView?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    // MARK: - Set Glassmorphism Border

    private func applyGlassBorder(_ attributes: GlassBorderAttributes) {
        glassmorphismView?.removeFromSuperview()
        borderLayer?.removeFromSuperlayer()
        self.layer.borderWidth = 0
        
        let outerPath = UIBezierPath(roundedRect: bounds, cornerRadius: attributes.cornerRadius)
        let innerRect = bounds.insetBy(dx: attributes.width, dy: attributes.width)
        let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: max(0, attributes.cornerRadius - attributes.width/2))
        outerPath.append(innerPath.reversing())
        
        glassmorphismView = GlassmorphismView(attributes.glassmorphismType)
        
        if let glassmorphismView = glassmorphismView {
            self.insertSubview(glassmorphismView, at: 0)
            glassmorphismView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = outerPath.cgPath
            maskLayer.fillRule = .evenOdd
            
            let maskView = UIView(frame: bounds)
            maskView.layer.addSublayer(maskLayer)
            glassmorphismView.mask = maskView
        }
    }
    
}
