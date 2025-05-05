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
            
            if let blurIntensity = style.blurIntensity,
               let blurEffectStyle = style.blurEffectStyle {
                setBlurEffect(blurIntensity, blurEffectStyle)
                    setGlassmorphism(glassmorphismType)
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
    
}
