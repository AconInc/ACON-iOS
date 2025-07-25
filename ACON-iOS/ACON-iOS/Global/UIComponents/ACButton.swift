//
//  ACButton.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/2/25.
//

import UIKit

class ACButton: UIButton {
    
    // MARK: - UI Properties
    
    private var glassmorphismView: GlassmorphismView?
    
    private var borderGlassmorphismView: GlassmorphismView?
    
    private var borderLayer: CAShapeLayer?
    
    
    // MARK: - Properties
    
    private var glassBorderAttributes: GlassBorderAttributes?
    
    private var buttonStyleType: ButtonStyleType = DefaultButton()
    
    private var title: String?
    
    var buttonState: GlassButtonState = .default
    
    
    // MARK: - Lifecycle
    
    init(
        style: ButtonStyleType,
        title: String? = nil,
        image: UIImage? = nil,
        isEnabled: Bool = true
    ) {
        super.init(frame: .zero)
        
        // TODO: 일부 glass 버튼 때문에 buttonStyleType & title 저장, 추후 더 나은 구조로 리팩
        self.buttonStyleType = style
        self.title = title
        setButton(style, title, image, isEnabled)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - Set Default Button Properites

extension ACButton {
    
    private func setButton(_ style: ButtonStyleType,
                   _ title: String? = nil,
                   _ image: UIImage? = nil,
                   _ isEnabled: Bool = true) {
        if let style = style as? ConfigButtonStyleType {
            setConfig(style)
        }
        buttonStyleType = style
        setButtonStyle(style, title, image, isEnabled)
        self.do {
            $0.title = title
            $0.imageView?.image = image
            $0.isEnabled = isEnabled
        }
    }
    
    
    // MARK: - Set Button Configuration
    
    private func setConfig(_ style: ConfigButtonStyleType) {
        
        var config: UIButton.Configuration
        
        switch style.configStyle {
        case .filled:
            config = .filled()
        case .plain:
            config = .plain()
        @unknown default:
            config = .plain()
        }

        config.baseBackgroundColor = .clear

        config.imagePlacement = style.imagePlacement
        config.imagePadding = style.imagePadding

        config.titleAlignment = style.titleAlignment
        contentHorizontalAlignment = style.titleAlignment.toContentHorizontalAlignment

        config.contentInsets = style.contentInsets
        
        config.showsActivityIndicator = style.showsActivityIndicator
        
        self.configuration = config
    }
    
    
    // MARK: - Set Button Style
    
    private func setButtonStyle(_ style: ButtonStyleType,
                                _ title: String?,
                                _ image: UIImage?,
                                _ isEnabled: Bool) {
        
        self.do {
            $0.backgroundColor = style.backgroundColor
            
            if let glassmorphismType = style.glassmorphismType {
                setGlassmorphism(glassmorphismType)
            }
            
            if let borderGlassmorphismType = style.borderGlassmorphismType {
                glassBorderAttributes = GlassBorderAttributes(width: style.borderWidth,
                                                              cornerRadius: style.cornerRadius,
                                                              glassmorphismType: borderGlassmorphismType)
            }
            
            $0.isEnabled = isEnabled
            
            $0.layer.cornerRadius = style.cornerRadius
            
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
    
}


// MARK: - 버튼 속성 업데이트 메소드

extension ACButton {
    
    func updateButtonTitle(_ title: String) {
        self.title = title
        self.setAttributedTitle(text: title,
                                style: buttonStyleType.textStyle,
                                color: buttonStyleType.textColor)
    }
    
    func updateButtonImage(_ image: UIImage) {
        self.setImage(image, for: .normal)
    }
    
}


// MARK: - GlassButton 관련 메소드 -


// MARK: - Set Glassmorphism / Glassmorphism Border

extension ACButton {
    
    ///Set Glassmorphism
    private func setGlassmorphism(_ glassmorphismType: GlassmorphismType) {
        glassmorphismView?.removeFromSuperview()
        self.backgroundColor = .clear
        
        glassmorphismView = GlassmorphismView(glassmorphismType).then {
            self.insertSubview($0, at: 0)
            $0.isUserInteractionEnabled = false
        }

        glassmorphismView?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    /// Set Glassmorphism Border
    private func applyGlassBorder(_ attributes: GlassBorderAttributes) {
        guard bounds.width > 0 && bounds.height > 0 else { return }
        
        borderGlassmorphismView?.removeFromSuperview()
        borderLayer?.removeFromSuperlayer()
        self.layer.borderWidth = 0
        
        let outerPath = UIBezierPath(roundedRect: bounds, cornerRadius: attributes.cornerRadius)
        let innerRect = bounds.insetBy(dx: attributes.width, dy: attributes.width)
        let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: max(0, attributes.cornerRadius - attributes.width/2))
        outerPath.append(innerPath.reversing())
        
        borderGlassmorphismView = GlassmorphismView(attributes.glassmorphismType)
        
        if let glassmorphismView = borderGlassmorphismView {
            if let backgroundView = self.glassmorphismView {
                self.insertSubview(glassmorphismView, aboveSubview: backgroundView)
            } else {
                self.insertSubview(glassmorphismView, at: 0)
            }
            
            glassmorphismView.isUserInteractionEnabled = false
            
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        glassmorphismView?.layer.cornerRadius = self.layer.cornerRadius
        glassmorphismView?.layer.masksToBounds = true
        
        if let attributes = glassBorderAttributes,
           bounds.width > 0, bounds.height > 0 {
            if let existingView = borderGlassmorphismView {
                if existingView.frame.size == bounds.size &&
                    existingView.frame.width > 0 && existingView.frame.height > 0 {
                    return
                }
            }
            applyGlassBorder(attributes)
        }
    }
    
}


// MARK: - Update GlassButton State

extension ACButton {

    // TODO: 전체적으로 번잡(엣지케이스 등), 추후 리팩 예정
    /// 메소드 단순화 / GlassButton Class 따로 빼기 / 프로퍼티들 단일화  등 고려
    func updateGlassButtonState(state: GlassButtonState) {
        let glassType: GlassmorphismType
        
        self.buttonState = state
        
        self.isEnabled = true
        self.isSelected = false
        self.isHighlighted = false
        
        switch state {
        case .disabled:
            self.isEnabled = false
            glassType = .buttonGlassDisabled
            self.setAttributedTitle(text: title ?? "",
                                    style: buttonStyleType.textStyle,
                                    color: .gray300,
                                    for: .disabled)
        case .pressed:
            self.isHighlighted = true
            glassType = .buttonGlassPressed
        case .selected:
            self.isSelected = true
            glassType = .buttonGlassSelected
        case .loading:
            self.isEnabled = false
            glassType = .buttonGlassDefault
        default:
            /// default
            glassType = .buttonGlassDefault
        }
        
        // NOTE: 글모 적용
        self.refreshButtonBlurEffect(glassType)
        
        // NOTE: 로딩 이미지 추가/해제
        if state == .loading {
            self.setAttributedTitle(nil, for: .normal)
            self.setImage(.icProgress, for: .normal)
            if let imageView = self.imageView {
                self.bringSubviewToFront(imageView)
            }
        } else {
            self.setAttributedTitle(text: title ?? "",
                                    style: buttonStyleType.textStyle,
                                    color: buttonStyleType.textColor)
            self.setImage(nil, for: .normal)
        }
        
        // NOTE: 엣지 케이스 : 보더 변경사항
        if self.buttonStyleType.glassButtonType == .full_19_b1R {
            if state == .selected {
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.acWhite.cgColor
            } else {
                self.layer.borderWidth = 0
            }
        }
    }
    
}

// MARK: - Refresh Glassbutton BlurEffect

extension ACButton {
    
    // NOTE: 정상적인 버튼 글라스모피즘 적용을 위해 Cell prepareForReuse에서 호출
    func refreshButtonBlurEffect(_ glassType: GlassmorphismType) {
        if buttonStyleType.glassmorphismType != nil {
            setGlassmorphism(glassType)
        }
        
        if let attributes = glassBorderAttributes {
            let updatedAttributes = GlassBorderAttributes(
                width: attributes.width,
                cornerRadius: attributes.cornerRadius,
                glassmorphismType: glassType
            )
            applyGlassBorder(updatedAttributes)
        }
    }
    
}
