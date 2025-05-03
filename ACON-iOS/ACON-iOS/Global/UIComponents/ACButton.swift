//
//  ACButton.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/2/25.
//

import UIKit

class ACButton: UIButton {
    
    private var blurView: UIVisualEffectView?
    
//    private var vibrancyView: UIVisualEffectView?
    
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
     
    
    // MARK: - Set Blur Effect
    
    private func setBlurEffect(_ blurIntensity: CGFloat, _ blurEffectStyle: UIBlurEffect.Style) {

        self.backgroundColor = .clear
        
        blurView?.removeFromSuperview()
        blurView = UIVisualEffectView(effect: nil).then {
            self.insertSubview($0, at: 0)
        }
        blurView?.setBlurDensity(blurIntensity, blurEffectStyle)
        blurView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // vibrancy 관련
//        vibrancyView?.removeFromSuperview()
//        vibrancyView = UIVisualEffectView(effect: vibrancyEffect).then {
//            blurView?.contentView.addSubview($0)
//        }
//        vibrancyView?.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        blurView?.layer.cornerRadius = self.layer.cornerRadius
        blurView?.layer.masksToBounds = true
    }
    
}
