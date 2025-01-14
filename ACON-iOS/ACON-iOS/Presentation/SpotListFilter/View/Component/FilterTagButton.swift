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
            print("button isSelected")
            configuration?.baseBackgroundColor = isSelected ? .subOrg35 : .gray8
            configuration?.background.strokeColor = isSelected ? .org1 : .gray6
        }
    }
    
    
    // MARK: - Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

// MARK: - UI Settings

private extension FilterTagButton {
    
    func configureButton() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .gray8
        config.baseForegroundColor = .acWhite
        config.background.strokeColor = .gray6
        config.background.strokeWidth = 1
        config.cornerStyle = .capsule
        config.titleAlignment = .center
        config.contentInsets = NSDirectionalEdgeInsets(top: 7,
                                                       leading: 16,
                                                       bottom: 7,
                                                       trailing: 16)
        
        self.configuration = config
        
    }
    
}
