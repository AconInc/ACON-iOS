//
//  GlassBorderAttributes.swift
//  ACON-iOS
//
//  Created by 이수민 on 5/23/25.
//

import Foundation

struct GlassBorderAttributes {
    
    let width: CGFloat
    
    let cornerRadius: CGFloat
    
    let glassmorphismType: GlassmorphismType
    
    init(width: CGFloat, cornerRadius: CGFloat, glassmorphismType: GlassmorphismType) {
        self.width = width
        self.cornerRadius = cornerRadius
        self.glassmorphismType = glassmorphismType
    }
    
}
