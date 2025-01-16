//
//  SpotSegmentedControl.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/16/25.
//

import UIKit

import Then

// TODO: 커스텀 세그먼트컨트롤 만들기...
/// - 배경 insets
/// - attributed string

class CustomSegmentedControl: UISegmentedControl {
    

    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
////        self.removeBackgroundAndDivider()
//    }
    
    init() {
        let segmentItems = [StringLiterals.SpotListFilter.restaurant,
                            StringLiterals.SpotListFilter.cafe]
        super.init(items: segmentItems)
        
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // TODO: 커스텀
    private func removeBackgroundAndDivider() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func setStyle() {
        self.do {
            $0.selectedSegmentIndex = 0
            $0.selectedSegmentTintColor = .acWhite
            $0.backgroundColor = .gray8
            $0.setTitleTextAttributes(String.ACStyle(.s2, .gray5), for: .normal)
            $0.setTitleTextAttributes(String.ACStyle(.s2, .gray9), for: .selected)
        }
    }
}
