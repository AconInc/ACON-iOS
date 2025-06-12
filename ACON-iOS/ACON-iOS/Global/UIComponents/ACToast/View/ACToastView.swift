//
//  ACToastView.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/23/25.
//

import UIKit

final class ACToastView: GlassmorphismView {
    
    //MARK: - UI Properties
    
    private let messageLabel: UILabel = UILabel()
    
    private let tapAction: (() -> Void)?
    
    private var acToastType: ACToastType
    
    
    // MARK: - LifeCycle
    
    init(_ acToastType: ACToastType, _ tapAction: (() -> Void)?) {
        self.acToastType = acToastType
        self.tapAction = tapAction
        
        super.init(.toastGlass)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        addSubviews(messageLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        self.snp.makeConstraints {
            $0.height.equalTo(acToastType.height)
            $0.width.equalTo(ScreenUtils.widthRatio*328)
        }
        
        messageLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.widthRatio*18)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.do {
            $0.layer.cornerRadius = acToastType.glassBorderAttributes.cornerRadius
            $0.clipsToBounds = true
        }
        
        messageLabel.setLabel(text: acToastType.title,
                              style: acToastType.titleFont,
                              color: acToastType.titleColor,
                              alignment: .center)
        
        addTapAction()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.addGlassBorder(acToastType.glassBorderAttributes)
        self.refreshBlurEffect()
    }

}


// MARK: - Tap Action

private extension ACToastView {
    
    @objc
    func handleTapAction() {
        tapAction?()
        self.removeFromSuperview()
    }
    
    func addTapAction() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleTapAction))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
}
