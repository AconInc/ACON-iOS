//
//  PriorityLowEmptyView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/16/25.
//

import UIKit

class PriorityLowEmptyView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
