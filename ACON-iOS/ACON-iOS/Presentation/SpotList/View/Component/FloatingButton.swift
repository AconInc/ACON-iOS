//
//  FloatingButton.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/20/25.
//

import UIKit

class FloatingButton: GlassmorphismView {
    
    // MARK: - Properties
    
    let button = UIButton()
    
    private let image: UIImage?
    private let size: CGFloat
    
    
    // MARK: - LifeCycles
    
    init(image: UIImage?, size: CGFloat = 36) {
        self.image = image
        self.size = size
        
        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.addSubview(button)
    }
    
    override func setLayout() {
        super.setLayout()
        
        self.snp.makeConstraints {
            $0.size.equalTo(size)
        }
        
        button.snp.makeConstraints {
            $0.size.equalTo(size * 0.67)
            $0.center.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = size / 2
        
        button.setImage(image, for: .normal)
    }
    
}
