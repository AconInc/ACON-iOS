//
//  HapticManager.swift
//  ACON-iOS
//
//  Created by 이수민 on 6/10/25.
//

import UIKit

final class HapticManager {
    
    static let shared = HapticManager()
    
    // heavy, light, meduium, rigid, soft
    func hapticImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func hapticSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
}
