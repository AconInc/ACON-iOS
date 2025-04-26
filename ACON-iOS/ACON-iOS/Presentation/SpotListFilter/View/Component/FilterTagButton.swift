//
//  FilterTagButton.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/14/25.
//

import UIKit

class FilterTagButton: UIButton {
    
    // MARK: - Basic Properties
    
    override var isSelected: Bool {
        didSet {
            configuration?.baseBackgroundColor = isSelected ? .primaryLight.withAlphaComponent(0.35) : .gray800
            configuration?.background.strokeColor = isSelected ? .primaryDefault : .gray600
        }
    }
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureButton()
        setLayout()
        addTarget()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}


// MARK: - UI Settings

private extension FilterTagButton {
    
    func configureButton() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .gray800
        config.baseForegroundColor = .acWhite
        config.background.strokeColor = .gray600
        config.background.strokeWidth = 1
        config.cornerStyle = .capsule
        config.titleAlignment = .center
        config.titleLineBreakMode = .byTruncatingTail
        config.contentInsets = NSDirectionalEdgeInsets(top: 7,
                                                       leading: 16,
                                                       bottom: 7,
                                                       trailing: 16)
        self.configuration = config
    }
    
    func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(32)
        }
    }
    
    func addTarget() {
        self.addTarget(self, action: #selector(toggleSelf), for: .touchUpInside)
    }
    
}


// MARK: - @objc functions

private extension FilterTagButton {
    
    @objc
    func toggleSelf(_ sender: UIButton) {
        isSelected.toggle()
    }
    
}
