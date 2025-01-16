//
//  SpotSegmentedControl.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/16/25.
//

import UIKit

// TODO: 커스텀 세그먼트컨트롤 만들기...
/// - 배경 insets
/// - attributed string

class CustomSegmentedControl: UISegmentedControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.removeBackgroundAndDivider()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        self.removeBackgroundAndDivider()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func removeBackgroundAndDivider() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
}
