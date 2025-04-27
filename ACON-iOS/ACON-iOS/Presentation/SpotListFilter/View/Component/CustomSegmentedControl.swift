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
            $0.backgroundColor = .gray800
            $0.setTitleTextAttributes(ACStyle(.s2, .gray500), for: .normal)
            $0.setTitleTextAttributes(ACStyle(.s2, .gray900), for: .selected)
        }
    }
    
    func ACStyle(_ style: OldACFontStyleType, _ color: UIColor = .acWhite) -> [NSAttributedString.Key: Any] {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .kern: style.kerning,
            .paragraphStyle: {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.minimumLineHeight = style.lineHeight
                paragraphStyle.maximumLineHeight = style.lineHeight
                return paragraphStyle
            }(),
            .foregroundColor: color,
            .baselineOffset: (style.lineHeight - style.font.lineHeight) / 2
        ]
        
        return attributes
    }
    
}
