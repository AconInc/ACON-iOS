//
//  ThumbView.swift
//  ACON-iOS
//
//  Created by 김유림 on 1/23/25.
//

import UIKit

class WideTouchView: UIView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // NOTE: 모든 방향에 10만큼 터치 영역 증가
        // NOTE: dx: x축이 dx만큼 증가 (음수여야 증가)
        let touchAreaInset: CGFloat = -30
        let touchArea = bounds.insetBy(dx: touchAreaInset, dy: touchAreaInset)
        return touchArea.contains(point)
    }
    
}
